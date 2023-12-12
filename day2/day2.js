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

MAX_CUBES = { red: 12, green: 13, blue: 14}

const cubes = async (filename) => {
    const data = await fs.readFile(filename, 'utf8');
    const lines = data.split('\n');

    const findMax = (data, searchTerm) => {
        searchStr = '\\d+\\s' + searchTerm;
        let candidates = data.match(new RegExp(searchStr, "g"));
        candidates = candidates.map((str) => { return Number(str.match(/\d+/)[0]) } )
        // console.log(candidates)
        return Math.max(...candidates);
    }

    const myData = lines.map((line) => {
        let [game, data] = line.split(/:/);
        game = game.match(/\d/)[0];

        const red = findMax(data, 'red');
        const green = findMax(data, 'green');
        const blue  = findMax(data, 'blue');

        return { game: game, red: red, green: green, blue: blue }
    })

    // console.log(myData);

    const possibleGames = [];
    for (let i in myData) {
        let gameItem = myData[i];
        // console.log(gameItem);
        // console.log(gameItem.red);
        // console.log(MAX_CUBES.red)
        if (gameItem.red <= MAX_CUBES.red &&
        gameItem.green <= MAX_CUBES.green && 
        gameItem.blue <= MAX_CUBES.blue) {
            possibleGames.push(Number(gameItem.game));
        }
    }
    // console.log(myData);
    // console.log(possibleGames)
    return possibleGames.reduce((accum, item) => accum + item);
}

tools.test(cubes, 'testfile1.txt', 8);