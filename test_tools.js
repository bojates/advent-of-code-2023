
const test = (func, filename, expectedAnswer) => {
    func(filename).then(answer => {
        if (answer === expectedAnswer) {
            console.log("Success: " + expectedAnswer);
        } else {
            console.log("=== nope! Got: " + answer + ' but expected: ' + expectedAnswer);
        }
    }).catch(err => {
        console.error(err);
    });
}
exports.test = test;