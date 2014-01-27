// Use this to customize the wymeditor boot process
// Just mirror the options specified in boot_wym.js with the new options here.
// This will completely override anything specified in boot_wym.js for that key.
// e.g. skin: 'something_else'
if (typeof(custom_wymeditor_boot_options) == "undefined") {
	custom_wymeditor_boot_options = {
		classesItems: [
			{name: 'text-align', rules:[
				{name: 'left', title: '{Left}'},
				{name: 'center', title: '{Center}'},
				{name: 'right', title: '{Right}'},
				{name: 'justify', title: '{Justify}'}
				], join: '-', title: '{Text_Align}'},
			{name: 'image-align', rules:[
				{name: 'left', title: '{Left}'},
				{name: 'right', title: '{Right}'}
				], join: '-', title: '{Image_Align}'},
			{name: 'font-size', rules:[
				{name: 'small', title: '{Small}'},
				{name: 'normal', title: '{Normal}'},
				{name: 'large', title: '{Large}'}
				], join: '-', title: '{Font_Size}'}
		],

		containersItems: [
			{'name': 'h1', 'title':'Heading_1', 'css':'wym_containers_h1'},
			{'name': 'h2', 'title':'Heading_2', 'css':'wym_containers_h2'},
			{'name': 'h3', 'title':'Heading_3', 'css':'wym_containers_h3'},
			{'name': 'p', 'title':'Paragraph', 'css':'wym_containers_p'},
			{'name': 'PRE', 'title': 'Preformatted', 'css': 'wym_containers_pre'},
			{'name': 'BLOCKQUOTE', 'title': 'Blockquote', 'css': 'wym_containers_blockquote'},
			{'name': 'TH', 'title': 'Table_Header', 'css': 'wym_containers_th'}
		],

		toolsItems: [
			{'name': 'Bold', 'title': 'Bold', 'css': 'wym_tools_strong'},
			{'name': 'Italic', 'title': 'Emphasis', 'css': 'wym_tools_emphasis'},
			{'name': 'Superscript', 'title': 'Superscript', 'css': 'wym_tools_superscript'},
			{'name': 'Subscript', 'title': 'Subscript', 'css': 'wym_tools_subscript'},
			{'name': 'InsertUnorderedList', 'title': 'Unordered_List', 'css': 'wym_tools_unordered_list'},
			{'name': 'InsertOrderedList', 'title': 'Ordered_List', 'css': 'wym_tools_ordered_list'},
			{'name': 'Indent', 'title': 'Indent', 'css': 'wym_tools_indent'},
			{'name': 'Outdent', 'title': 'Outdent', 'css': 'wym_tools_outdent'},
			{'name': 'Undo', 'title': 'Undo', 'css': 'wym_tools_undo'},
			{'name': 'Redo', 'title': 'Redo', 'css': 'wym_tools_redo'},
			{'name': 'CreateLink', 'title': 'Link', 'css': 'wym_tools_link'},
			{'name': 'Unlink', 'title': 'Unlink', 'css': 'wym_tools_unlink'},
			{'name': 'InsertImage', 'title': 'Image', 'css': 'wym_tools_image'},
			{'name': 'InsertTable', 'title': 'Table', 'css': 'wym_tools_table'},
			{'name': 'Paste', 'title': 'Paste_From_Word', 'css': 'wym_tools_paste'},
			{'name': 'ToggleHtml', 'title': 'HTML', 'css': 'wym_tools_html'},
//			{'name': 'Preview', 'title': 'Preview', 'css': 'wym_tools_preview'}
		]
	};
}
