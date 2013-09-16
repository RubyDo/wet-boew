###
JQuery Helper Methods v1.0
Release: 31/07/2013
Author: WET Community
Credits: http://kaibun.net/blog/2013/04/19/a-fully-fledged-coffeescript-boilerplate-for-jquery-plugins/


Web Experience Toolkit (WET) / Boîte à outils de l'expérience Web (BOEW)
wet-boew.github.io/wet-boew/License-en.html / wet-boew.github.io/wet-boew/Licence-fr.html
###

do ( $ = jQuery, window, document ) ->
	$this = undefined

	_settings =
		default: 'wet-boew'

	methods =
		init: (options) ->
			$this = $(@)
			$.extend _settings, (options or {})
			return $this
		show: (onlyAria) ->
			$this = $(@)
			return $this.each ()->
				elm = $(@)
				elm.attr 'aria-hidden', 'false'
				unless onlyAria?
					elm.removeClass 'wb-invisible'
		hide: (onlyAria) ->
			$this = $(@)
			return $this.each ()->
				elm = $(@)
				elm.attr 'aria-hidden', 'true'
				unless onlyAria?
					elm.addClass 'wb-invisible'
		toggle: (to, from) ->
      $(@).addClass(to).removeClass(from)
	$.fn.wb = (method) ->
		if methods[method]
			methods[method].apply @, Array::slice.call(arguments, 1)
		else if typeof method is "object" or not method
			methods.init.apply @, arguments
		else
			$.error "Method " + method + " does not exist on jquery.wb"

###
:focusable and :tabable jQuery helper expressions - https://github.com/jquery/jquery-ui/blob/24756a978a977d7abbef5e5bce403837a01d964f/ui/jquery.ui.core.js
###
do ( $ = jQuery, window, document ) ->
  # selectors
  focusable = (element, isTabIndexNotNaN) ->
    map = undefined
    mapName = undefined
    img = undefined
    nodeName = element.nodeName.toLowerCase()
    if "area" is nodeName
      map = element.parentNode
      mapName = map.name
      return false  if not element.href or not mapName or map.nodeName.toLowerCase() isnt "map"
      img = $("img[usemap=#" + mapName + "]")[0]
      return !!img and visible(img)
    
    # the element and all of its ancestors must be visible
    ((if /input|select|textarea|button|object/.test(nodeName) then not element.disabled else (if "a" is nodeName then element.href or isTabIndexNotNaN else isTabIndexNotNaN))) and visible(element)
  
  visible = (element) ->
    $.expr.filters.visible(element) and not $(element).parents().addBack().filter(->
      $.css(this, "visibility") is "hidden"
    ).length
  
  $.extend $.expr[":"],
    data: (if $.expr.createPseudo then $.expr.createPseudo((dataName) ->
      (elem) ->
        !!$.data(elem, dataName)
    
    # support: jQuery <1.8
    ) else (elem, i, match) ->
      !!$.data(elem, match[3])
    )
    focusable: (element) ->
      focusable element, not isNaN($.attr(element, "tabindex"))

    tabable: (element) ->
      tabIndex = $.attr(element, "tabindex")
      isTabIndexNaN = isNaN(tabIndex)
      (isTabIndexNaN or tabIndex >= 0) and focusable(element, not isTabIndexNaN)