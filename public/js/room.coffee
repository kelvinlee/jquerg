# main.coffee
read = true;
path = "ace/mode/"
# dom = require "ace/lib/dom"
popshow = (id)->

_aFinished = []
finishedLoad = (options)->
	console.log options
	_aFinished.push options
	return init() if _aFinished.length >=4
init = -> 
	$('#loading').fadeOut 800

aEditorList = []
fGetEditors = ()->
	aN = [];
	aN.push name:e.name,type:e.type,content:e.editor.getSession().getValue() for e in aEditorList
	aN
fGetEditor = (name)->
	return editor if name is 'main'
	return e.editor for e in aEditorList when e.name is name
fCheckEditor = (name)->
	return yes if name is 'main'
	return yes for e in aEditorList when e.name is name
	no
fDelEditor = (name)->
	anewlist = []
	for e in aEditorList
		continue if e.name is name
		anewlist.push e
	aEditorList = anewlist
fDestroyEditer = (name)->
	fDelEditor name
	$('#'+name).next().remove()
	$('#'+name).remove()
createEditor = (name,type = 'javascript')->
	return true if fCheckEditor name 
	S = $ '<span>'
	A = $ '<a href="javascript:void(0)">'
	C = $ '<pre>'
	D = $ '<div>'
	S1 = S.clone().addClass('editorname').text name
	S2 = S.clone().addClass('editortype').text type
	A.addClass 'typcn'
	A.attr 'for',name
	Box = D.clone().addClass 'box'
	Box.append A.clone().removeClass('typcn').addClass('boxname').append(S1).append(' / ').append S2
	Box.append A.clone().addClass 'typcn-media-play-outline' if type is 'javascript' or type is 'coffee'
	Box.append A.clone().addClass 'typcn-cog-outline'
	Box.append A.clone().addClass 'typcn-heart'
	Box.append A.clone().addClass 'typcn-document-delete'
	Box.append A.clone().addClass 'typcn-arrow-maximise'
	Box.append A.clone().addClass 'typcn-arrow-minimise hide'
	D.addClass 'editor_ctrl clearfix'
	D.append Box
	C.attr 'id',name
	C.addClass 'editor'
	$('#editorlist').append C
	$('#editorlist').append D

	E = ace.edit name 
	E.setTheme "ace/theme/twilight" 
	E.getSession().setMode path+type
	E.on "change", (e)->
		if read
			socket.emit 'editor',
				deltas:e.data
				name:name
	aEditorList.push name:name,type:type,editor:E
	false
	
editor = {}
createEditor_default = ->
	editor = ace.edit "main" 
	editor.setTheme "ace/theme/twilight" 
	editor.getSession().setMode path+"javascript" 
	editor.on "change", (e)-> 
		if read 
			socket.emit 'editor',
				deltas:e.data
				name:"main"
	finishedLoad 'create default editor'

# socket to www.jquerg.com
socket = {}
connect_socket = (url)->
	socket = io.connect url
	socket.on 'online list', (data)->
		$("#n_p").text data.length
	socket.emit 'login', data:'first'
	# get who is the first user and get content.
	socket.on 'get default info', (data)-> 
		socket.emit 'create default info', 
			who:data.who
			content:editor.getSession().getValue()
			list:fGetEditors()
	# set editor content for everyone
	socket.on 'create default info', (data)-> 
		read = false 
		editor.getSession().setValue data.content
		console.log data.list
		for e in data.list
			if !createEditor e.name,e.type
				nE = fGetEditor e.name
				nE.getSession().setValue e.content
		read = true 
	# lisent everyone when thay send
	socket.on 'editor', (data)-> 
		read = false
		Se = fGetEditor data.name
		Se.getSession().getDocument().applyDeltas [data.deltas]
		read = true
	# listen when someone create a new editer
	socket.on 'create editor', (data)->
		createEditor data.name,data.type
	# listen when someone destroy an editor
	socket.on 'destroy editor', (data)->
		fDestroyEditer data.name
	# chat to everyone , no privte
	socket.on 'chat', (data)->

	socket.on 'action', (data)->
	# socket.on 'video', fVideo

	finishedLoad 'socket link...'

# video start
meeting = new Meeting()
oVideoList = document.getElementById 'videolist'
meeting.openSignalingChannel = (callback)->
	socket.on 'message', callback
meeting.onaddstream = (e)->
	console.log e
	$("#videolist").prepend e.video if e.type is 'local' and $('#self').length <= 0
	$("#videolist").append e.video  if e.type is 'remote' 
startVideo = ()->
	meeting.setup()

# video end
runjs = (ed)->
	type = ed.getSession().$modeId.replace 'ace/mode/',''
	if type is 'coffee'
		js = CoffeeScript.compile ed.getSession().getValue(), bare: on
		
	else if type is 'javascript'
		js = ed.getSession().getValue()
	else
		return no
	try
		eval js
	catch error then alert error
# bind key event
require("ace/commands/default_commands").commands.push({
    name: "runjs",
    bindKey: "Command-Return",
    exec: runjs
},{
    name: "runjs2",
    bindKey: "ctrl-Return",
    exec: runjs
})

# when loaed
setTimeout ->
	finishedLoad 'loading show'
,4500
$ ->
	$("select[name='modelist']").selectpicker style: 'btn-primary', menuStyle: 'dropdown-inverse'
	$("input[name=create]").click ->
		if $("input[name=filename]").val() 
			if createEditor $("input[name=filename]").val(),$("select[name='modelist']").val()
				alert '文件名已存在'
			else
				socket.emit 'create editor', 
					name:$("input[name=filename]").val()
					type:$("select[name='modelist']").val()
			$("input[name=filename]").val ''
		else
			alert '请输入文件名'
	$(document).on 'click' ,'.typcn-arrow-maximise' , -> 
		Mname = $(this).attr 'for' 
		$('#'+Mname).addClass 'fullScreen'
		$(this).parents('.editor_ctrl').addClass 'fullbox'
		$(this).addClass 'hide'
		$(this).next().removeClass 'hide'
	$(document).on 'click' ,'.typcn-arrow-minimise' , -> 
		Mname = $(this).attr 'for' 
		$('#'+Mname).removeClass 'fullScreen'
		$(this).parents('.editor_ctrl').removeClass 'fullbox'
		$(this).addClass 'hide'
		$(this).prev().removeClass 'hide'
	$(document).on 'click' ,'.typcn-document-delete', ->
		socket.emit 'destroy editor',name:$(this).attr 'for'
		fDestroyEditer $(this).attr 'for'
	$(document).on 'click' ,'.typcn-media-play-outline', -> 
		runjs fGetEditor $(this).attr 'for' 

	$("[name=url]").val window.location.href
	createEditor_default()
	finishedLoad 'bind btn event'
	
	connect_socket '#{config.clienturl}'

