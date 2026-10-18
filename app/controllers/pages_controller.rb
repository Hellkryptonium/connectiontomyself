class PagesController < ApplicationController
  def about
    render_site_page("about", "About", "A little about the person behind this site")
  end

  def now
    render_site_page("now", "Now", "What is happening here lately")
  end

  def colophon
    render_site_page("colophon", "Colophon", "About this website")
  end

  def writings
    redirect_to writings_path
  end

  def projects
    @projects = Project.recent
    render :projects
  end

  def project
    @project = Project.find_by!(slug: params[:slug])
  end

  def links
    @links = Link.ordered
    render :links
  end

  def uses
    render_site_page("uses", "Uses", "Tools and setup")
  end

  def privacy
    render_site_page("privacy", "Privacy", "How this site handles information")
  end

  def guestbook
    redirect_to guestbook_index_path
  end

  def subscribe
    render :subscribe
  end

  private

  def render_page(title, subtitle, paragraphs)
    @page_title = title
    @page_subtitle = subtitle
    @paragraphs = paragraphs
    render :show
  end

  def render_site_page(slug, fallback_title, fallback_subtitle)
    page = SitePage.find_by(slug: slug)
    render_page(
      page&.title || fallback_title,
      page&.subtitle || fallback_subtitle,
      page ? [ MarkdownRenderer.call(page.body_markdown) ] : [ "[Editable placeholder] Add this page in the admin area." ]
    )
  end
end
