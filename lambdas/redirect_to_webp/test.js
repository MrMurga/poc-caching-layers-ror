const lambda = require('./redirect_to_webp');
const tests = require('./test_payload.json');
const utilities = require('../utilities');

let result = utilities.performTest(tests["tests"], lambda);
return utilities.check(result, tests["tests".length]);