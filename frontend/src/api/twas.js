import { request } from '../utils/request.js'

function reqSPrediXcan(data) {
    return request({
        url: '/api/v1/twas/s-predixcan',
        method: 'post',
        data: JSON.stringify(data),
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

function reqFUSION(data) {
    return request({
        url: '/api/v1/twas/fusion',
        method: 'post',
        data: JSON.stringify(data),
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

function runSPrediXcanMashr(data) {
    return request({
        url: '/api/v1/twas/s-predixcan-mashr',
        method: 'post',
        data: JSON.stringify(data),
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

function runSPrediXcanEnet(data) {
    return request({
        url: '/api/v1/twas/s-predixcan-enet',
        method: 'post',
        data: JSON.stringify(data),
        headers: {
            'Content-type': 'application/json; charset=UTF-8',
        },
    })
}

export default {
    reqSPrediXcan,
    reqFUSION,
    runSPrediXcanMashr,
    runSPrediXcanEnet,
}