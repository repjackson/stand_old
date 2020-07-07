if Meteor.isClient
    Router.route '/user/:username/pictures', (->
        @layout 'profile_layout'
        @render 'user_pictures'
        ), name:'user_pictures'

    Template.user_pictures.onCreated ->
        @autorun => Meteor.subscribe 'docs', selected_tags.array(), 'thought'


    Template.user_pictures.onCreated ->
        @autorun => Meteor.subscribe 'user_pictures', Router.current().params.username
        @autorun => Meteor.subscribe 'model_docs', 'picture'

    Template.user_pictures.events
        'keyup .new_picture': (e,t)->
            if e.which is 13
                val = $('.new_picture').val()
                console.log val
                target_user = Meteor.users.findOne(username:Router.current().params.username)
                Docs.insert
                    model:'picture'
                    body: val
                    target_user_id: target_user._id



    Template.user_pictures.helpers
        user_pictures: ->
            target_user = Meteor.users.findOne(username:Router.current().params.username)
            Docs.find
                model:'picture'
                target_user_id: target_user._id

        slots: ->
            Docs.find
                model:'slot'
                _author_id: Router.current().params.user_id


if Meteor.isServer
    Meteor.publish 'user_pictures', (username)->
        Docs.find
            model:'picture'
