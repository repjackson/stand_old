if Meteor.isClient
    Router.route '/', (->
        @layout 'layout'
        @render 'home'
        ), name:'home'

    Template.home.onCreated ->
        @autorun => Meteor.subscribe 'model_docs', 'debit'
        @autorun => Meteor.subscribe 'model_docs', 'credit'
        @autorun => Meteor.subscribe 'model_docs', 'email_signup'
        @autorun => Meteor.subscribe 'all_users'
        @autorun -> Meteor.subscribe('home_tag_results',
            selected_tags.array()
            selected_location_tags.array()
            selected_authors.array()
            Session.get('view_purchased')
            # Session.get('view_incomplete')
            )
        @autorun -> Meteor.subscribe('home_results',
            selected_tags.array()
            selected_location_tags.array()
            selected_authors.array()
            Session.get('view_purchased')
            # Session.get('view_incomplete')
            )

    Template.home.helpers
        credits: ->
            Docs.find
                model:'credit'
        debits: ->
            Docs.find
                model:'debit'
        email_signups: ->
            Docs.find
                model:'email_signup'

    Template.home.events
        'click .add_home': ->
            new_id =
                Docs.insert
                    model:'home'
            Router.go "/home/#{new_id}/edit"
        'keydown .submit_email': (e,t)->
            # email = $('submit_email').val()
            if e.which is 13
                email = $('.submit_email').val()
                if email.length > 0
                    Docs.insert
                        model:'email_signup'
                        email_address:email
                    $('body')
                      .toast({
                        class: 'success'
                        position: 'top right'
                        message: "#{email} added to list"
                      })
                    $('.submit_email').val('')




    # Template.home_card.events
    #     'click .record_home': ->
    #         Meteor.users.update Meteor.userId(),
    #             $inc: points:-@points
    #         $('body').toast({
    #             class: 'info',
    #             message: "#{@points} spent"
    #         })
    #         Docs.insert
    #             model:'home_item'
    #             parent_id: @_id