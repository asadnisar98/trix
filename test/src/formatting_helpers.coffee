getToolbarButton = ({attribute, action}) ->
  getToolbarElement().querySelector("button[data-attribute='#{attribute}'], button[data-action='#{action}']")

getToolbarDialog = ({attribute, action}) ->
  getToolbarElement().querySelector(".dialog[data-attribute='#{attribute}'], .dialog[data-action='#{action}']")

@clickToolbarButton = (selector, callback) ->
  button = getToolbarButton(selector)
  triggerEvent(button, "mousedown")
  defer(callback)

@typeToolbarKeyCommand = (selector, callback) ->
  button = getToolbarButton(selector)
  if {key} = button.dataset
    keyCode = key.toUpperCase().charCodeAt(0)
    triggerEvent(getDocumentElement(), "keydown", {keyCode, charCode: 0, metaKey: true, ctrlKey: true})
  defer(callback)

@clickToolbarDialogButton = ({method}, callback) ->
  button = getToolbarElement().querySelector(".dialog input[type=button][data-method='#{method}']")
  triggerEvent(button, "click")
  defer(callback)

@isToolbarButtonActive = (selector) ->
  button = getToolbarButton(selector)
  button.classList.contains("active")

@isToolbarButtonDisabled = (selector) ->
  getToolbarButton(selector).getAttribute("disabled") is "disabled"

@typeInToolbarDialog = (string, {attribute}, callback) ->
  dialog = getToolbarDialog({attribute})
  input = dialog.querySelector("input[name='#{attribute}']")
  button = dialog.querySelector("input[data-method='setAttribute']")
  input.value = string
  triggerEvent(button, "click")
  defer(callback)

@isToolbarDialogActive = (selector) ->
  dialog = getToolbarDialog(selector)
  dialog.classList.contains("active")

@expectAttributes = (range, attributes) ->
  locationRange = getDocument().locationRangeFromRange(range)
  document = getDocument().getDocumentAtLocationRange(locationRange)
  blocks = document.getBlocks()
  throw "range #{JSON.stringify(range)} spans more than one block" unless blocks.length is 1

  textIndex = locationRange.index
  textRange = [locationRange.start.offset, locationRange.end.offset]
  text = getDocument().getTextAtIndex(textIndex).getTextAtRange(textRange)
  pieces = text.getPieces()
  throw "range #{JSON.stringify(range)} must only span one piece" unless pieces.length is 1

  piece = pieces[0]
  deepEqual piece.getAttributes(), attributes

@expectBlockAttributes = (range, attributes) ->
  locationRange = getDocument().locationRangeFromRange(range)
  document = getDocument().getDocumentAtLocationRange(locationRange)
  blocks = document.getBlocks()
  throw "range #{JSON.stringify(range)} spans more than one block" unless blocks.length is 1

  block = blocks[0]
  deepEqual block.getAttributes(), attributes

@expectHTML = (trixDocument, html) ->
  equal getHTML(trixDocument), html

@getHTML = (trixDocument) ->
  Trix.DocumentView.render(trixDocument).innerHTML
