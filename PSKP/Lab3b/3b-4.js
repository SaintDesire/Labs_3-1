import { v4 as uuid } from 'uuid'

const createOrder = async card => {
    return new Promise((resolve, reject) => {
        try {
            if (!validateCard(card)) {
                throw 'Card is not valid'
            }
            return setTimeout(() => {
                resolve(uuid())
            }, 5000)
        } catch (e) {
            reject(e)
        }
    })
}

const validateCard = card => {
    console.log('Card number: ', card)
    return Math.random() * 100 > 50
}

const proceedToPayment = async number => {
    return new Promise((resolve, reject) => {
        Math.random() * 100 > 50 ?
            resolve('Payment successfull') :
            reject('Payment failed')
    })
}

const main = async (number, card) => {
    try {
        console.log('Order ID: ', await createOrder(card))
        console.log(await proceedToPayment(number))
    } catch (e) {
        console.error(e)
    }
}

main(1332123, 8888995959)