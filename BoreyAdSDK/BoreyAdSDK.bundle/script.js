let platform = ''

function init(params) {

    platform = params.platform
    const timeOutSecond = params.time_out_second
    const statusBarHeight = params.status_bar_height
    let url = params.img_url
    let count = timeOutSecond
    let contentBg = document.getElementById('content-bg');
    let closeBtn = document.getElementById('close-btn');
    let container = document.getElementById('container');
    let img = document.getElementById('img')
    
    if (statusBarHeight) {
        closeBtn.style.top = statusBarHeight + 'px'
    }
    
    img.addEventListener('load', () => {
        let opacity = 0
        let timer = setInterval(() => {
            opacity += 0.07
            img.style.opacity = opacity >= 1 ? 1 : opacity
            if (opacity >= 1) {
                clearInterval(timer)
            }
        }, 20)
    })
    img.src = url
    closeBtn.innerText = '跳过' + count + 's'
    let timeoutTimer = setInterval(() => {
        count--
        if (count == 0) {
            closeBtn.innerText = '跳过'
            clearInterval(timeoutTimer)
            webToNative('time_reached', {})
        } else {
            closeBtn.innerText = '跳过' + count + 's'
        }
    }, 1000)

    container.addEventListener('touchstart', (e) => {
        startY = e.touches[0].clientY;
    });

    container.addEventListener('touchend', (e) => {
        const endY = e.changedTouches[0].clientY;
        const deltaY = endY - startY;
        if (deltaY < 0) {
            clearInterval(timeoutTimer)
            webToNative('click_ad', {
                'type': 'swipe'
            })
        }
        if(deltaY == 0) {
            clearInterval(timeoutTimer)
            webToNative('click_ad', {
                'type': 'click'
            })
        }
    });
    closeBtn.addEventListener('click', (e) => {
        clearInterval(timeoutTimer)
        webToNative('click_close_btn', {})
    })
    
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
