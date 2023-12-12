const fs = require('fs').promises;
const tools = require('../test_tools');

const myFunc = async (filename) => {
    const data = await fs.readFile(filename, 'utf8');
    const lines = data.split('\n');
    const numbersObj = { "1": "1", "2": "2", "3": "3", "4": "4", "5": "5", "6": "6", "7": "7", "8": "8", "9": "9", 
            "one": "1", 
            "two": "2", 
            "three": "3", 
            "four": "4", 
            "five": "5", 
            "six": "6",
            "seven": "7",
            "eight": "8", 
            "nine": "9"}

    const testLine = new RegExp(Object.keys(numbersObj).join('|'), "g");

    const res = lines.map((line) => {
        const lineArr = matchOverlap(line, testLine);
        const numbers = lineArr.map((numberStr) => numbersObj[numberStr]);
        return Number(numbers[0] + numbers[numbers.length -1]);
    })

    return res.reduce((accumulator, element) => accumulator + element, 0)
}

// https://stackoverflow.com/questions/20833295/how-can-i-match-overlapping-strings-with-regex
// Loop our Object and if we find values, add them to a holding array
function matchOverlap(input, re) {
    let retArr = [], match;
    // Prevent infinite loops
    if (!re.global) {
        re = new RegExp(
        re.source, (re+'').split('/').pop() + 'g'
        );
    }
    while (match = re.exec(input)) {
        re.lastIndex -= match[0].length - 1;
        retArr.push(match[0]);
    }
    return retArr;
}

tools.test(myFunc, 'testfile.txt', 142);
tools.test(myFunc, 'testfile2.txt', 281);
tools.test(myFunc, 'input.txt', 53592); // 55621 for the uncalibrated. 53587 was wrong. Too low. 
