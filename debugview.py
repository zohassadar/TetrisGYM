import argparse
import dataclasses
import pathlib
import re

OUTPUT_EXTENSION = "txt"


@dataclasses.dataclass
class Segment:
    id: int
    name: str
    start: int
    size: int
    rom_offset: int


@dataclasses.dataclass
class Files:
    rom: pathlib.Path
    debug: pathlib.Path
    list: pathlib.Path
    output: pathlib.Path


def kvsplit(line):
    section, line = re.split(
        r"\s+",
        line,
        maxsplit=1,
    )
    line = line.strip().split(",")
    result = {}
    for kv in line:
        k, v = kv.split("=")
        result[k] = v
    return section, result


def valid_rom(rompath):
    path = pathlib.Path(rompath)
    if not path.exists():
        raise argparse.ArgumentTypeError("{path} does not exist")
    debugfile = path.parent / f"{path.stem}.dbg"
    listfile = path.parent / f"{path.stem}.lst"
    outputfile = path.parent / f"{path.stem}.{OUTPUT_EXTENSION}"
    files = Files(
        path,
        debugfile,
        listfile,
        outputfile,
    )
    if not files.debug.exists():
        raise argparse.ArgumentTypeError(f"missing {path.stem}.dbg")
    if not files.list.exists():
        raise argparse.ArgumentTypeError(f"missing {path.stem}.lst")
    return files


parser = argparse.ArgumentParser()
parser.add_argument("rom", type=valid_rom)
files = parser.parse_args().rom

rom = open(files.rom, "rb").read()


dbgfile = open(files.debug).read()
segments = {}
for seg in re.findall(r"^seg.*", dbgfile, flags=re.M):
    _, kvs = kvsplit(seg)
    id_ = int(kvs["id"])
    name = eval(kvs["name"])
    start = eval(kvs["start"])
    size = eval(kvs["size"])
    rom_offset = eval(kvs.get("ooffs", "0"))
    segment = Segment(
        id_,
        name,
        start,
        size,
        rom_offset,
    )
    segments[name] = segment

segment = segments["ZEROPAGE"]

output = []
"""
examples:
0002F0r 2  xx xx xx xx  statsByType: .res $E ; $03F0
0001C4r 2  BD rr rr             lda soundEffectSlot0FrameCounter,x
000BC5r 2  rr rr                .addr   render_mode_rocket
000BEBr 2  85 rr                sta currentPpuCtrl
"""
for line in (l.strip() for l in open(files.list).readlines()):
    if line.endswith(".bss"):
        segment = segments["BSS"]
    if match := re.search(r'\.segment\s+"(\w+)"', line):
        if seg := segments.get(match.group(1)):
            segment = seg
    try:
        offset = int(line[:6], 16)
    except ValueError:
        output.append(line)
        continue
    address = offset + segment.start

    bytecode = line[11:23]
    bytecode = bytecode.replace("xx", "  ")
    # possible rr positions
    bcs = [
        bytecode[:2],
        bytecode[3:5],
        bytecode[6:8],
    ]
    for i in range(len(bcs)):
        if bcs[i] == "rr":
            bcs[i] = f"{rom[offset + segment.rom_offset + i]:02X}"

    # only show address for ram & if bytes exist
    address = f"{address:04X}" if bytecode.strip() or ".res" in line else "    "
    output.append(f"{address} {' '.join(bcs)} {bytecode[9:]} {line[23:]}")

open(files.output, "w+").write("\n".join(output))
