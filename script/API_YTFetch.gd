extends Control
class_name C_APIFetch

var U_Thumbnail
var U_Image = null
var U_LinkNR = ""
var API_Title = "Blank"
var API_Thumbnail
var API_YT = HTTPRequest.new()
var http_request = HTTPRequest.new()
var J_File


func F_FetchTitle(P_Link, P_CommitLink, P_APIKey):
	var i = 0
	while(i != len(P_Link) and P_Link[i] != "&"):
		U_LinkNR += P_Link[i]
		i += 1
	print(U_LinkNR)
	var P_FetchLink = P_CommitLink + U_LinkNR + P_APIKey
	U_LinkNR = ""
	print(P_FetchLink)
	await API_YT.request_completed.connect(self._on_HTTPRequest_request_completed)
	await API_YT.request(P_FetchLink)
	return [API_Title,API_Thumbnail]


func _on_HTTPRequest_request_completed(_result, _response_code, _headers, body):
	J_File = JSON.parse_string(body.get_string_from_utf8())
	print(J_File.items[0].snippet.title)
	API_Title = J_File.items[0].snippet.title
	API_Thumbnail = J_File.items[0].snippet.thumbnails.medium.url
	F_FetchThumbnail(API_Thumbnail)


func F_FetchThumbnail(P_Link):
	http_request.request_completed.connect(self._http_request_completed)
	http_request.request(P_Link)


func _http_request_completed(_result, _response_code, _headers, body):
	var image = Image.new()
	image.load_jpg_from_buffer(body)
	U_Image = ImageTexture.create_from_image(image)
