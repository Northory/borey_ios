let platform = ''
function init(params) {

    platform = params.platform
    let descView = document.getElementById('desc')
    let titleView = document.getElementById('title')
    let imgView = document.getElementById('logo-icon')
    let contentContainer = document.getElementById('root-container')
    let closeIcon = document.getElementById('close-icon')

    let expectHeight = params.expect_height_dp
    let desc = params.desc
    let title = params.title
    let brandLogo = params.brand_logo
    let imgHeight = (expectHeight - 10) + 'px'
    let imgWidth = imgHeight

    descView.innerText = desc
    titleView.innerText = title
    imgView.style.height = imgHeight
    imgView.style.width = imgWidth
    contentContainer.style.height = expectHeight + 'px'

    imgView.addEventListener('load', function () {
        contentContainer.style.visibility = 'visible'
    })

    closeIcon.addEventListener('click', function () {
        closeAd()
    })

    imgView.src = brandLogo

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