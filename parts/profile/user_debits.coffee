if Meteor.isClient
    Router.route '/user/:username/spent', (->
        @layout 'profile_layout'
        @render 'user_debits'
        ), name:'user_debits'

    Template.user_debits.onCreated ->
        @autorun => Meteor.subscribe 'docs', selected_tags.array(), 'thought'


    Template.user_debits.onCreated ->
        @autorun => Meteor.subscribe 'user_debits', Router.current().params.username
        @autorun => Meteor.subscribe 'model_docs', 'debit'

    Template.user_debits.events
        'keyup .new_debit': (e,t)->
            if e.which is 13
                val = $('.new_debit').val()
                console.log val
                target_user = Meteor.users.findOne(username:Router.current().params.username)
                Docs.insert
                    model:'debit'
                    body: val
                    target_user_id: target_user._id



    Template.user_debits.helpers
        user_debits: ->
            target_user = Meteor.users.findOne(username:Router.current().params.username)
            Docs.find
                model:'debit'
                target_user_id: target_user._id

        slots: ->
            Docs.find
                model:'slot'
                _author_id: Router.current().params.user_id


if Meteor.isServer
    Meteor.publish 'user_debits', (username)->
        Docs.find
            model:'debit'
