let platform = ''
function init(params) {

    platform = params.platform
    let descView = document.getElementById('desc')
    let imgView = document.getElementById('img')
    let imgBgView = document.getElementById('img-bg')
    let imgContainer = document.getElementById('img-container')
    let contentContainer = document.getElementById('content-container')
    let adLabel = document.getElementById('ad-label')

    let expectHeight = params.expect_height_dp
    let imgUrl = params.img_url
    let desc = params.title
    let imgHeight = (expectHeight - contentContainer.offsetHeight) + 'px'
    descView.innerText = desc
    imgView.style.height = imgHeight
    imgContainer.style.height = imgHeight
    imgBgView.style.height = imgHeight

    imgView.addEventListener('load', function () {
        contentContainer.style.visibility = 'visible'
        adLabel.style.visibility = 'visible'
    })

    imgView.src = imgUrl
    imgBgView.src = imgUrl

}

function clickAd() {
    webToNative('click_ad', {})
}

function closeAd() {
    webToNative('click_close_btn', {})
}

function webToNative(method, params) {
    let data = {
        'method': method,
        'params': params
    }
    let strData = JSON.stringify(data)
    if (platform == 'android') {
        NativeBridge.webToNative(strData)
    } else if (platform == 'ios') {
        window.webkit.messageHandlers.NativeBridge.postMessage(strData);
    }
}

function nativeToWeb(data) {
    let method = data.method
    let params = data.params
    if (method == 'init') {
        init(params)
    }
}