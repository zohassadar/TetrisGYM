const fs = require('fs');
const path = require('path');

function format(line) {
    line = line.trimEnd().replace(/^\t+/, (_) => ' '.repeat(4 * _.length));

    if (!line.trim().startsWith(';')) {
        line = line.replace(/^\s*(\.?\w+)(\s*)([^;\s]*)/, '    $1 $3');
        line = line.replace(/^\s*(\w+)\s*(:?)\s*(=)\s*(.+)/i, '$1 $2$3 $4');
        line = line.replace(/^\s*(\w+)\s*:\s*(?:(;)\s*(.*))?/i, '$1: $2 $3');
        line = line.replace(/^\s*([A-Z]\w+)\s*$/, '$1');
        line = line.replace(/^\s*\.(if|enum|endenum|endif|out|include)/, '.$1');
    } else {
        line = line.trim();
    }

    return line.trimEnd();

}

(function processFiles(directory) {
    const files = fs.readdirSync(directory);

    files.forEach(file => {
        const filePath = path.join(directory, file);
        const stat = fs.statSync(filePath);

        if (stat.isDirectory()) {
            processFiles(filePath);
        } else if (file == 'menu.asm') {
            const content = fs.readFileSync(filePath, 'utf8');
            let formatted = content.split('\n').map(format).join('\n');
            if (formatted.at(-1) !== '\n') {
                formatted += '\n';
            }
            fs.writeFileSync(filePath, formatted);
        }
    });
})(process.cwd());
