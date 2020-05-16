// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/app.scss'

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import 'phoenix_html'
import { Socket } from 'phoenix'
import NProgress from 'nprogress'

import { LiveSocket } from 'phoenix_live_view'

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute('content')

// Show progress bar on live navigation and form submits
window.addEventListener('phx:page-loading-start', (info) => NProgress.start())
window.addEventListener('phx:page-loading-stop', (info) => NProgress.done())

let Hooks = {}
Hooks.piece = {
  mounted() {
    this.el.addEventListener('dragstart', (e) => {
      e.dataTransfer.dropEffect = 'move'
      e.dataTransfer.setData('old_square', e.target.dataset.square)
      e.dataTransfer.setData('text/plain', e.target.id)
    })

    this.el.addEventListener('dragover', (e) => {
      e.preventDefault()
      e.dataTransfer.dropEffect = 'move'
    })

    this.el.addEventListener('drop', (e) => {
      e.preventDefault()
      updateSquare(e, this)
    })
  },
}

Hooks.square = {
  mounted() {
    this.el.addEventListener('dragover', (e) => {
      e.preventDefault()
      e.dataTransfer.dropEffect = 'move'
    })

    this.el.addEventListener('drop', (e) => {
      e.preventDefault()

      updateSquare(e, this)
    })
  },
}

const updateSquare = (ev, hook) => {
  var old_square = ev.dataTransfer.getData('old_square')
  var new_square =
    (hook.el && hook.el.dataset && hook.el.dataset.square) || hook.el.id

  var move_notation = old_square + new_square
  hook.pushEvent('move', { move: move_notation })
}

let liveSocket = new LiveSocket('/live', Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
})

// connect if there are any LiveViews on the page
liveSocket.connect()

// window.addEventListener('phx:game-active', phxUpdateListener)

// function phxUpdateListener(_event) {}

// expose liveSocket on window for web console debug logs and latency simulation:
// liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket
