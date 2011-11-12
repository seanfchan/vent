module ApplicationHelper
	#Return a title on a per-page basis
	def title
		base_title = "Vent"
		if (@title.nil?)
			base_title
		else
			"#{base_title} | #{@title}"
		end
	end

  def logo
    image_tag("logo.png", :alt => "Vent", :class => "round")
  end

  def upvote
    image_tag("upvote.png", :alt => "UpVote", :class => "round")
  end
end
