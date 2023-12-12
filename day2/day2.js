/*
# Problem: 
Cubes are either red, green or blue. 
Multiple games. 
For each game, we get a sample of the cubes. 
Each line is a Game, and identified with a number (Game 1 etc.)
Each sample is semicolon separated, and each count and colour is comma separated. 

We are then given maximum cubes for each colour and asked which games would have been possible. 
Grab the game number. 
Sum the game numbers. 
This is our answer. 

# Example: 
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green

What is possible with 12 red, 13 green, 14 blue? 
Answer: 1, 2, 5. 
Not 3 because we don't have 20 red cubes. 
Not 4 because we don't have 15 blue cubes. 
Return: 8 (sum 1, 2, 5)

# Data: 
Input: 
 - Text file formulated as above
 - Limit values e.g. (red = 12, green = 13, blue = 14)
 Output: integer

# Algorithm:
Read the file
For each line, extract the game number, and largest number for each of the colours. 
{ game: int, red: int, green: int, blue: int }

Filter this data using the limit values
Grab the game numbers
Sum them
*/

const fs = require('fs').promises;
const tools = require('../test_tools');

MAX_CUBES = { red: 12, green: 13, blue: 14 }

const cubes = async (filename) => {
    const data = await fs.readFile(__dirname + '/' + filename, 'UTF-8');
    const lines = data.split('\n');
    
    const gameData = buildGameData(lines);
    
    const filteredData = gameData.filter((item) => {
        if (item.red <= MAX_CUBES.red &&
            item.green <= MAX_CUBES.green && 
            item.blue <= MAX_CUBES.blue) {
                return true;
            }
        }).map((item) => item.game )
        
    return filteredData.reduce((accum, item) => accum + item, 0);
}

function buildGameData(lines) {
    return lines.map((line) => {
        let [game, data] = line.split(/:/);
        game = Number(game.match(/\d+/)[0]);
        
        return { game: game, 
                red: findMax(data, 'red'), 
                green: findMax(data, 'green'), 
                blue: findMax(data, 'blue') }
    })
}

function findMax(data, searchTerm) {
    const searchStr = '\\d+\\s' + searchTerm;
    let candidates = data.match(new RegExp(searchStr, "g"));
    candidates = candidates.map((str) => Number(str.match(/\d+/)[0]))
    return Math.max(...candidates);
}

const getPowers = async (filename) => {
    const data = await fs.readFile(__dirname + '/' + filename, 'UTF-8');
    const lines = data.split('\n');
    
    const gameData = buildGameData(lines);
    return gameData
        .map((game) => game.red * game.green * game.blue)
        .reduce((collect, item) => collect + item, 0)
}

tools.test(cubes, 'testfile1.txt', 8);
tools.test(cubes, 'input.txt', 2563); 

tools.test(getPowers, 'testfile1.txt', 2286)
tools.test(getPowers, 'input.txt', 70768)