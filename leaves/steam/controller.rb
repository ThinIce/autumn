# Controller for the Steam leaf. REMEMBER put your Group Name in config.yml!
# TODO Very basic, goes remote each command. Should make use of cached data.
# TODO Does not yet make use of views.
# TODO Better output of members list.
# TODO Querying of game servers members are playing on.
# TODO Other stats, favourite group game, time playing etc.

class Controller < Autumn::Leaf

  # Typing "!about" displays some basic information about this leaf.

  def about_command(stem, sender, reply_to, msg)
    # This method renders the file "about.txt.erb"
  end

  # Displays a count of the members in the group.
  
  def groupmembers_command(stem, sender, reply_to, msg)
         group = SteamGroup.new(options[:group])
         stems.message('Currently ' +  group.member_count.to_s() + ' members are in our steam group.',reply_to)
  end

  # Outputs all members in the group. May not be suitable for large groups as one per line
  
  def groupnames_command(stem, sender, reply_to, msg)
         group = SteamGroup.new(options[:group])
         # We have to fetch to populate member data
         group.members.each {  |member| member.fetch }
         group.members.each {  |member| stems.message(member.nickname,reply_to) }
  end

  # Outputs the group URL
  
  def groupurl_command(stem, sender, reply_to, msg)
         group = SteamGroup.new(options[:group])
         stems.message('On steam we are ' +  group.base_url,reply_to)
  end

  # Display members of the group in game
  
  def steamgaming_command(stem, sender, reply_to, msg)
        isgaming = false
        group = SteamGroup.new(options[:group])
        # We have to fetch to populate is in game
        group.members.each {  |member| member.fetch }
        group.members.each {  |member| if member.is_in_game? then
                stems.message(member.nickname + ' is: ' + stripstatemessage(member.state_message),reply_to) 
                isgaming = true
        end  }
        if isgaming == false then
                stems.message('No one is gaming :(',reply_to)
        end
  end

  # Display members of the group online

  def steamonline_command(stem, sender, reply_to, msg)
        isonline = false
        group = SteamGroup.new(options[:group], true)
        group.members.each {  |member| member.fetch }
        group.members.each {  |member| if member.is_online? then 
                stems.message(member.nickname + ' is online.',reply_to)
                isonline = true 
        end }
        if isonline == false then
                stems.message('No one is online :(',reply_to)
        end
  end

  # Helper function to remove HTML tag
  
  def stripstatemessage(message)
        # rip out the br tag and replace with a space
        result = message.gsub(%r{</?[^>]+?>}, ' ')
        return result
  end

end