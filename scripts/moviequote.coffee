# Description:
#   Movie quote search w/ video response (via quotacle.com)
#
# Commands:
#   hubot moviequote me <query> - Searches quotacle for the movie quote and returns the result.
# 
# Author:
#   nitzmahone
module.exports = (robot) ->
  robot.respond /(?:moviequote)(?: me)? (.*)/i, (msg) ->
    query = msg.match[1]
    robot.http("http://quotacle.com/autocomplete.php")
      .header("Accept","application/json, text/javascript, */*; q=0.01")
      .header("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
      .post("input=" + encodeURIComponent(query)) (err, res, body) ->
        if not body? or body is ''
          return msg.send "No quote results for \"#{query}\""

        console.log "body was " + body

        videos = JSON.parse(body)

        unless videos? && videos.length > 0
          return msg.send "No quote results for \"#{query}\""

        video  = msg.random videos
        msg.send "*#{video[3]}* _\"#{video[0]}\"_\n#{video[1]}"
