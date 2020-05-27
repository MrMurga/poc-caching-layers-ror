'use strict';

/**
 * This lambda fetches the path requested from a mirror site
 * Lambda Type: Origin Response
 */

const DEBUGGING = true;

async function fetch(url) {
    console.log('start request to ' + url);
    let promise = new Promise((resolve, reject) => {
        var body = '';
        var https = require('https');
        https
            .get(url, function (res) {
                console.log(`GET ${url} ${res.statusCode}`);
                res.on('data', function (chunk) {
                    body += chunk;
                });
                res.on('end', function () {
                    console.log(`GET ${url} ${res.statusCode} COMPLETE`);
                    let response = {
                        error: false,
                        result: {
                            /*headers: res.headers,*/
                            body: body,
                            status: res.statusCode,
                            statusDescription: "OK"
                        }
                    };
                    resolve(response);
                });
            })
            .on('error', function (e) {
                console.log(`GET ${url} ${res.statusCode} ERROR ${e.message}`);
                let response = { error: true, result: Error(e) };
                reject(response)
            });
    });

    var response = await promise;
    console.log('end request to ' + url);
    return response;
}

function log(str) {
    if (DEBUGGING) {
        console.log(str);
    }
}

exports.handler = async (event, context, callback) => {
    const request = event.Records[0].cf.request;
    let uri = request.uri;
    let url = 'https://gusto.com' + uri;

    console.log(`Received URI: ${uri} forwarding to ${url}`);

    let response = await fetch(url);
    if (response == null) {
        console.log("Result invalid");

        callback(Error("invalid fetch"));
    } else if (response.error) {
        console.log("There was an error");

        callback(response.result);
    }
    console.log("Success");
    callback(null, response.result);
};