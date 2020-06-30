@selected_tags = new ReactiveArray []
@selected_authors = new ReactiveArray []
@selected_location_tags = new ReactiveArray []
@selected_tribes = new ReactiveArray []

Template.nav.onCreated ->
    @autorun => Meteor.subscribe 'me'
