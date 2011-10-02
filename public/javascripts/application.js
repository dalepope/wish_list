// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// move focus to first form element
window.onload = function() {
  if (window.location.hash === "")
  {
    Form.focusFirstElement(document.forms[0]);
  }
}
