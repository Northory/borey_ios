let platform = ''

function init(params) {

    platform = params.platform
    const config = params.config
    const statusBarHeight = params.status_bar_height
    const timeOutSecond = config?.skip_time_seconds || 5
    let clickAreaRatio = config?.click_area_ratio || 0.3
    if (clickAreaRatio >= 1) {
        clickAreaRatio = 1
    } else if (clickAreaRatio <= 0) {
        clickAreaRatio = 0.3
    }
    let url = params.img_url
    let count = timeOutSecond
    let clickArea = document.getElementById('click-area');
    let closeBtn = document.getElementById('close-btn');
    let img = document.getElementById('img')
    
    if (statusBarHeight) {
        closeBtn.style.top = statusBarHeight + 'px'
    }
    
    clickArea.style.height = clickAreaRatio * 100 + '%'
    closeBtn.style.visibility = "visible"
    
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

    clickArea.addEventListener('touchstart', (e) => {
        startY = e.touches[0].clientY;
    });

    clickArea.addEventListener('touchend', (e) => {
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
