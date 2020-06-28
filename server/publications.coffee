Meteor.publish 'user_from_username', (username)->
    # console.log 'pulling doc'
    Meteor.users.find
        username:username



Meteor.publish 'all_users', ()->
    Meteor.users.find()
