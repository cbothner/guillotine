function closePrint() {
  document.body.removeChild(this.__container__);
}

function setPrint() {
  this.contentWindow.__container__ = this;
  this.contentWindow.onbeforeunload = closePrint;
  this.contentWindow.onafterprint = closePrint;
  this.contentWindow.focus(); // Required for IE
  this.contentWindow.print();
}

var x = document.createElement('iframe');
x.style.visibility = 'hidden';
x.style.position = 'fixed';
x.style.right = '0';
x.style.bottom = '0';
x.style.width = '8.5in';
x.style.height = '11in';
x.src = '<%= donation_credit_card_form_path(donation_id) %>';
x.onload = setPrint;

document.body.appendChild(x);
