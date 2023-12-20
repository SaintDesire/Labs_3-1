function f1() {
    console.log('f1')
}

function f2() {
    console.log('f2')
}

function f3() {
    console.log('f3')
}

(function main() {
    console.log('main')

    setTimeout(f1, 50)
    setTimeout(f3, 30)

    new Promise((resolve) =>
        resolve('I am a Promise, right after f1 and f3! Really?')
    ).then(console.log)

    new Promise((resolve) =>
        resolve('I am a Promise after Promise!')
    ).then(console.log)

    f2()
})()