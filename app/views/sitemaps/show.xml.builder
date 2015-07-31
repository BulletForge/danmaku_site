xml.instruct!
xml.urlset "xmlns" => "http://www.google.com/schemas/sitemap/0.84" do
  xml.url do
    xml.loc         root_url
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
  end

  xml.url do
    xml.loc         users_url
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
  end

  xml.url do
    xml.loc         projects_url
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "weekly"
  end

  User.order("created_at DESC").each do |user|
    xml.url do
      xml.loc         user_url( user )
      xml.lastmod     w3c_date user.updated_at
      xml.changefreq  "weekly"
    end

    xml.url do
      xml.loc         user_projects_url(user)
      xml.lastmod     w3c_date(Time.now)
      xml.changefreq  "weekly"
    end

    user.projects.where("unlisted = false").order("created_at DESC").each do |project|
      xml.url do
        xml.loc         user_project_url( user, project )
        xml.lastmod     w3c_date(Time.now)
        xml.changefreq  "weekly"
      end
    end
  end
end