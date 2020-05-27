const DEBUGGING = false;

function log(str) {
    if (DEBUGGING) {
        console.log(str);
    }
}

exports.isEquivalent = function(a, b) {
    let stringA = JSON.stringify(a);
    let stringB = JSON.stringify(b);
    return stringA === stringB;
}

exports.performTest = function (testSuite, lambda, labelKey = "label", inputKey = "input", outputKey = "output") {
    const util = require("util");
    const total = testSuite.length;
    let failed = [];

    testSuite.forEach(test => {
        let val = null;
        lambda.handler(test[inputKey], null, (val1, val2) => {
            val = val2;
        });

        let match = exports.isEquivalent(test[outputKey], val);
        if (match) {
            return ;
        }

        log(`Failed test "${test[labelKey]}". Expected:`);
        log(util.inspect(test[outputKey], { depth: 10 }));
        log(`Received:`);
        log(util.inspect(val, { depth: 10 }));

        failed.push({
            getLabel() {
                return test[labelKey];
            },
            getExpected() {
                return test[outputKey];
            },
            getResult() {
                return val;
            },
            getMatch() {
                return false;
            }
        });
    });

    return { 
        getFailed() {
            return failed.length;
        },
        getFailedDetailed() {
            return failed;
        },
        getSuccess() {
            return total - failed.length;
        }
     };
}

exports.check = function (result, totalTests) {
    if (result.getFailed() != 0) {
        console.log(`This lambda failed ${result.getFailed()} tests out of ${totalTests}`);
        return false;
    }
    console.log(`This lambda passed all tests.`);
    return true;
}