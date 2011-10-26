### Permission system for forem

In many other forum systems out there, there are permission systems built into them. Forem is unique in that it's an engine and supposed to be pluggable into other applications, rather than being something standalone such as (my understanding) how phpBB and vBulletin work.

This complicates things. By creating our own permission system we would limit those people who may have their own permissions systems within their applications. This is definitely not ideal. Forem is already able to adapt to different *authentication* systems, so why not *authorization* also?

I propose that we build a flexible authorization system into Forem so that people can set up permissions on their forem installs in the easiest way possible using their own authorization if that's what they have, or suggesting to use CanCan instead.

#### How it works

I think that we should have methods on the `User` class which define the permissions that people have. For example, there would be a `can_read_forum?` method which would take one argument and do something like this:

    def can_read_forum?(forum)
      permissions.where(:object => forum, :permission_type => "read")
    end

The code inside the `can_read_forum?` method will be application-specific, but the API for the permissions is something that we should provide.

There could even be a possibility that we provide a `Forem::Permissions::Default` module which, when included into a `User`-like class, would then provide defaults for these permission methods, which then can be overridden in the model as the application designers wish. I think it would be best to have a blacklist-by-default, but I am open to ideas on this one on why it's a bad idea if anybody thinks so.

## Alternative API

Alternatively we get them to include a module called `Forem::Permissions` which then provides the following API:

   can_read_forum do
     permissions.where(:object => forum, :permission_type => "read")
   end

This then will store the given block which will be executed (using `instance_eval`) on the `current_user` object.

## Caveats

With this kind of permission system I cannot think of a clean way that you could allow anonymous access to forums (for example). How could we fix that?