# main.coffee
read = true;
path = "ace/mode/"

popshow = (id)->

editorList = []
createEditor = (name,type = 'javascript')->
	name = 'jquerg_'+name
	C = $ '<pre>'
	D = $ '<div>'
	Box = D.clone().addClass 'box'
	Box.append 
	D.addClass 'editor_ctrl clearfix'
	D.append Box
	C.attr 'id',name
	C.addClass 'editor'
	$('#editorlist').append C
	$('#editorlist').append D

	E = ace.edit name 
	E.setTheme "ace/theme/twilight" 
	E.getSession().setMode path+type
	
editor = {}
createEditor_default = ->
	editor = ace.edit "main" 
	editor.setTheme "ace/theme/twilight" 
	editor.getSession().setMode path+"javascript" 
	editor.on "change", (e)-> 
		if read 
			socket.emit 'editor',deltas:e.data

# socket to www.jquerg.com
socket = {}
connect_socket = (url)->
	socket = io.connect url
	socket.on 'online list', (data)->
		$("#n_p").text data.length
	socket.emit 'login', data:'first'
	socket.on 'get default info', (data)-> 
		socket.emit 'create default info', 
			who:data.who
			content:editor.getSession().getValue()
	socket.on 'create default info', (data)-> 
		read = false
		editor.getSession().setValue data.content
		read = true

	socket.on 'editor', (data)-> 
		read = false
		editor.getSession().getDocument().applyDeltas [data.deltas]
		read = true

# when loaed
$ ->
	$("select[name='modelist']").selectpicker style: 'btn-primary', menuStyle: 'dropdown-inverse'
	$("input[name=create]").click ->
		if $("input[name=filename]").val() 
			createEditor $("input[name=filename]").val(),$("select[name='modelist']").val()
		else
			alert '请输入文件名'
	$('.typcn-arrow-maximise').on 'click', -> 
		Mname = $(this).attr 'for' 
		$('#'+Mname).addClass 'fullScreen'
		$(this).parents('.editor_ctrl').addClass 'fullbox'
		$(this).addClass 'hide'
		$(this).next().removeClass 'hide'
	$('.typcn-arrow-minimise').on 'click', -> 
		Mname = $(this).attr 'for' 
		$('#'+Mname).removeClass 'fullScreen'
		$(this).parents('.editor_ctrl').removeClass 'fullbox'
		$(this).addClass 'hide'
		$(this).prev().removeClass 'hide'
	$("[name=url]").val window.location.href
	createEditor_default()

