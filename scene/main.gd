extends Control


var I_APIFetch = C_APIFetch.new()
var I_FBDatabase = C_FBDatabase.new()
var I_FBRating = C_FBRating.new()
var I_APIKeys = C_APIKeys.new()

@onready var U_MenuAnim = $MenuAnimation
@onready var U_SearchKeyword = $Panel/SearchBox
@onready var U_PopupMenu = $PopupMenu
@onready var U_SubjectPopup = $SubjectPopup
@onready var U_UploadSubject = $SubjectPopup/SubjectEntry
@onready var U_UploadLink = $PopupMenu/UploadLink
@onready var U_LevelContainer = $PopupMenu/LevelContainer
@onready var U_SearchRes = $SearchResult/res_ItemList
@onready var U_ResThumbnail = $SearchResult/HTTPRequest
@onready var U_SubjectLevel = $SubjectLevel
@onready var U_ResultPopup = $ResultPopup
@onready var U_ResultPopupImage = $ResultPopup/VideoPopupBackground/ResultImg
@onready var U_ResultPopupTitle = $ResultPopup/VideoPopupBackground/ResultTitle
@onready var U_ResultPopupRateList = $ResultPopup/VideoPopupBackground/RatingList
@onready var U_ResultPopupDispRating = $ResultPopup/VideoPopupBackground/DispRating
@onready var U_CommitPosition = $PopupMenu/CommitPosition
@onready var U_CommitPositionList = $PopupMenu/CommitPosition/CommitPositionList
@onready var U_FirestoreCollection : FirestoreCollection = Firebase.Firestore.collection(I_APIKeys.U_CollectionName)
var im = Image.load_from_file("res://icon.svg")
#var DIR = OS.get_executable_path().get_base_dir()
#var PY_Interpreter = DIR.plus_file("venv/bin/")
#var PY_Interpreter = ProjectSettings.globalize_path("res://venv/bin/python3.9")
#var PY_Script = ProjectSettings.globalize_path("res://script/test.py")
var query: FirestoreQuery = FirestoreQuery.new()
var Img = ImageTexture.create_from_image(im)
var U_GlobalIndex
var U_CommitIndex
var is_panel_open
var U_SearchSubjectLevel
var U_Index
var U_CourseLevel
var U_LevelSelect
var U_Link
var U_Subject
var U_JSONFile
var U_query
var U_LinkID
var U_APIRequest = "https://youtube.googleapis.com/youtube/v3/videos?part=snippet&id"
var U_FetchLink
var U_Iterator
var U_Database
var U_RatingArr = []
var U_ImgLinks = []


func _ready():

	add_child(I_APIFetch.API_YT)
	add_child(I_APIFetch.http_request)
	if(OS.get_name() == "Android"):
		var _db_name = "user://datastore/RedirectData"
	is_panel_open = false


func F_InitCommit(P_CourseLevel):
	U_CourseLevel = P_CourseLevel
	F_CommitList(U_Subject, P_CourseLevel)
	U_CommitPosition.visible = true


func F_ResultPopup(P_Title, P_Thumbnail):
	U_ResultPopupImage.texture = P_Thumbnail
	U_ResultPopupTitle.text = P_Title


func F_DisplayRes(P_query, P_Level):
	U_RatingArr = []
	U_Database = await I_FBDatabase.F_FetchID(P_query, P_Level)
	U_Iterator = U_Database.get(P_Level)
	for i in range(0, len(U_Iterator)):
		var temp = ""
		var j = 0
		while(j != len(U_Iterator[i])):
			U_RatingArr.append("Be the first one to rate!")
			if(U_Iterator[i][j] == "&"):
				var k = j
				while(U_Iterator[i][k] != "$"):
					if(U_Iterator[i][k] != "&" and U_Iterator[i][k] != "$"):
						temp += U_Iterator[i][k]
					k += 1
					U_RatingArr[i] = temp
			j += 1
		I_APIFetch.F_FetchTitle(U_Iterator[i], U_APIRequest, I_APIKeys.U_YoutubeAPIKey)
		#I_APIFetch.F_FetchThumbnail(FetchResultThumbnail[i])
		await get_tree().create_timer(I_APIFetch.API_Title != null).timeout
		#FetchResultTitle.append(I_APIFetch.API_Title)
		#FetchResultThumbnail.append(I_APIFetch.API_Thumbnail)
	#print(FetchResultTitle, FetchResultThumbnail)
		#var FetchResultThumbnail = 
		#FetchPromises.append(FetchResult)
		#await get_tree().create_timer(1).timeout
	#for i in range(0, len(U_Iterator)):
		await get_tree().create_timer(I_APIFetch.U_Image == null).timeout
		U_SearchRes.add_item(I_APIFetch.API_Title, I_APIFetch.U_Image, true)
		I_APIFetch.U_Image = null
	U_JSONFile = I_APIFetch.J_File
	print(U_RatingArr.size())
	#await FetchPromises
	#for i in range(0, len(U_Iterator)):


func F_CommitList(P_query, P_Level):
	U_RatingArr = []
	U_Database = await I_FBDatabase.F_FetchID(P_query, P_Level)
	U_Iterator = U_Database.get(P_Level)
	for i in range(0, len(U_Iterator)):
		var temp = ""
		var j = 0
		while(j != len(U_Iterator[i])):
			if(U_Iterator[i][j] == "$Panel/SearchBox"):
				var k = j
				while(U_Iterator[i][k] != "$"):
					if(U_Iterator[i][k] != "&" and U_Iterator[i][k] != "$"):
						temp += U_Iterator[i][k]
					k += 1
				print(temp)
				U_RatingArr.append(temp)
			j += 1
		I_APIFetch.F_FetchTitle(U_Iterator[i], U_APIRequest, I_APIKeys.U_YoutubeAPIKey)
		await get_tree().create_timer(I_APIFetch.API_Title != null).timeout
		await get_tree().create_timer(I_APIFetch.U_Image == null).timeout
		U_CommitPositionList.add_item(I_APIFetch.API_Title, I_APIFetch.U_Image, true)
		I_APIFetch.U_Image = null
	U_CommitPositionList.add_item("New last item")
	U_JSONFile = I_APIFetch.J_File


func _on_upload_link_text_submitted(_new_text):
	U_Link = U_UploadLink.text
	U_LevelContainer.visible = true


func _on_search_box_text_submitted(_new_text):
	_on_search_button_button_up()


func _on_res_item_list_item_selected(index):
	U_GlobalIndex = index
	U_Index = index + 1
	var U_ResTitle = U_SearchRes.get_item_text(index)
	var U_ResThumbnail = U_SearchRes.get_item_icon(index)
	var U_Final = "https://www.youtube.com/watch?v" + U_Iterator[index]
	if(U_Index <= U_RatingArr.size()):
		U_ResultPopupDispRating.text = U_RatingArr[index]
	U_ResultPopup.visible = true
	F_ResultPopup(U_ResTitle, U_ResThumbnail)
	U_SearchRes.deselect_all()
	#OS.shell_open(U_Final)


func _on_swt_addlink_pressed():
	U_SubjectPopup.visible = true


func _on_b_beginner_pressed():
	U_CourseLevel = "Beginner"
	F_InitCommit(U_CourseLevel)
	U_LevelContainer.visible = false


func _on_b_intermediate_pressed():
	U_CourseLevel = "Intermediate"
	F_InitCommit(U_CourseLevel)
	U_LevelContainer.visible = false


func _on_b_advanced_pressed():
	U_CourseLevel = "Advanced"
	F_InitCommit(U_CourseLevel)
	U_LevelContainer.visible = false

func _on_search_button_button_up():
	U_query = U_SearchKeyword.text
	U_query = U_query.to_lower()
	U_Subject = U_query
	U_SubjectLevel.visible = true


func _on_texture_button_pressed():
	U_PopupMenu.visible = false
	U_LevelContainer.visible = false
	U_UploadLink.clear()


func _on_category_exit_button_up():
	U_PopupMenu.visible = false


func _on_button_side_menu_pressed():
	if(is_panel_open == false):
		U_MenuAnim.play("SideMenuOpen")
		is_panel_open = true
		return 0
	if(is_panel_open == true):
		U_MenuAnim.play("SideMenuCollapse")
		is_panel_open =false
		return 0


func _on_b_2_advanced_button_up():
	U_SearchSubjectLevel = "Advanced"
	F_DisplayRes(U_query, U_SearchSubjectLevel)
	U_SubjectLevel.visible = false
	U_SearchRes.clear()


func _on_b_2_intermediate_button_up():
	U_SearchSubjectLevel = "Intermediate"
	F_DisplayRes(U_query, U_SearchSubjectLevel)
	U_SubjectLevel.visible = false
	U_SearchRes.clear()


func _on_b_2_beginner_button_up():
	U_SearchSubjectLevel = "Beginner"
	F_DisplayRes(U_query, U_SearchSubjectLevel)
	U_SubjectLevel.visible = false
	U_SearchRes.clear()


func _on_subject_entry_text_submitted(_new_text):
	U_Subject = U_UploadSubject.text
	U_PopupMenu.visible = true
	U_SubjectPopup.visible = false


func _on_b_next_button_up():
	U_Subject = U_UploadSubject.text
	U_PopupMenu.visible = true
	U_SubjectPopup.visible = false


func _on_subject_exit_pressed():
	U_SubjectPopup.visible = false


func _on_b_2_exit_course_level_pressed():
	U_SubjectLevel.visible = false


func _on_exit_button_button_up():
	U_ResultPopup.visible = false
	U_ResultPopupRateList.deselect_all()
	U_ResultPopupRateList.visible = false


func _on_b_rate_button_up():
	U_ResultPopupRateList.deselect_all()
	U_ResultPopupRateList.visible = true


func _on_rating_list_item_selected(index):
	I_FBRating.F_FBCommitRating(U_Iterator, U_APIRequest, U_SearchSubjectLevel, U_FirestoreCollection, str(index + 1), U_Index - 1, U_Subject)
	U_RatingArr.append(str(index+1))
	U_ResultPopupRateList.deselect_all()
	U_ResultPopupRateList.visible = false


func _on_result_link_button_up():
	var U_Final = "https://www.youtube.com/watch?v" + U_Iterator[U_GlobalIndex]
	OS.shell_open(U_Final)


func _on_commit_position_list_item_selected(index):
	U_CommitPositionList.deselect_all()
	await I_FBDatabase.F_FBCommit(U_Link, U_APIRequest, U_CourseLevel, U_FirestoreCollection, U_Subject, index)
	U_CommitPosition.visible = false
	U_CommitPositionList.clear()


func _on_home_button_button_up():
	U_SearchRes.clear()


func _on_refresh_button_button_up():
	F_DisplayRes(U_query, U_SearchSubjectLevel)
