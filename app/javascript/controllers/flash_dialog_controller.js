import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    timeout: { type: Number, default: 6500 }
  }

  connect() {
    this.dismissed = false
    this.remainingTime = this.timeoutValue

    if (!this.element.open) this.element.setAttribute("open", "")
    this.resume()
  }

  disconnect() {
    this.clearTimer()
  }

  pause() {
    if (!this.timer) return

    this.remainingTime -= Date.now() - this.startedAt
    this.clearTimer()
  }

  resume() {
    if (this.dismissed || this.timeoutValue <= 0) return

    this.clearTimer()
    this.startedAt = Date.now()
    this.timer = window.setTimeout(
      () => this.dismiss(),
      Math.max(this.remainingTime, 1000)
    )
  }

  dismiss(event) {
    event?.preventDefault()
    if (this.dismissed) return

    this.dismissed = true
    this.clearTimer()
    this.element.classList.add("app-flash-dialog--leaving")

    window.setTimeout(() => {
      if (this.element.open && typeof this.element.close === "function") {
        this.element.close()
      }

      this.element.remove()
    }, 180)
  }

  clearTimer() {
    window.clearTimeout(this.timer)
    this.timer = null
  }
}
