crumb :root do
  link "トップページ", root_path
end

crumb :trip_new do
  link "新規作成"
  parent :root
end

crumb :user_new do
  link "アカウント作成"
  parent :root
end

crumb :user_session_new do
  link "ログイン"
  parent :root
end

crumb :user_show do
  link "マイページ", user_path(current_user.id)
  parent :root
end

crumb :trip_show do |trip|
  if params[:id] != nil &&
    (current_page?(controller: 'trips', action: 'show', id: params[:id]) ||
    current_page?(controller: 'trips', action: 'edit', id: params[:id]))
    trip = Trip.find(params[:id])
    link "旅行計画：#{trip.title}", trip_path(trip.id)
    parent :user_show
  else
    trip = Trip.find(params[:trip_id])
    link "旅行計画：#{trip.title}", trip_path(trip.id)
    parent :user_show
  end
end

crumb :trip_edit do |trip|
  trip = Trip.find(params[:id])
  link "編集", edit_trip_path(trip.id)
  parent :trip_show
end

crumb :detail_edit do |detail|
  detail = Detail.find(params[:id])
  link "スケジュールの編集：#{detail.title}", edit_trip_detail_path(detail.id)
  parent :trip_show
end

crumb :fixed_trip do
  link "旅行確定"
  parent :trip_show
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).