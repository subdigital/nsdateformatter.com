class Formatter {
    constructor() {
        this.dateInput = document.querySelector("input[name='date-input']");
        this.formatInput = document.querySelector("input[name='format']");
        this.localeSelect = document.querySelector("select[name='locale']");
        this.formatButton = document.querySelector("button[name='format-btn']");

        let doFormat = this.formatDate.bind(this);
        this.dateInput.addEventListener('change', doFormat);
        this.formatInput.addEventListener('change', doFormat);
        this.localeSelect.addEventListener('change', doFormat);
        this.formatButton.addEventListener('click', doFormat);
    }

    setDateResult(result) {
        document.querySelector("span.date-result").innerText = result
    }

    formatDate() {
        this.setDateResult("...")
        fetch("/format", {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                date: encodeURIComponent(this.dateInput.value),
                format: this.formatInput.value,
                timezoneOffset: (new Date().getTimezoneOffset() / - 60),
                locale: this.localeSelect.value
            })
        })
            .then((r) => r.text())
            .then((result) => {
                console.log(result)
                this.setDateResult(result)
            })
            .catch((e) => {
                console.error(e)
                this.setDateResult("")
            })
    }
}

export default Formatter;

