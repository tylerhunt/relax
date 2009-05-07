class Flickr < Relax::Service
  defaults do
    parameter :api_key, :required => true
  end

  endpoint "http://api.flickr.com/services/rest" do
    defaults do
      parameter :method, :required => true
    end

    action :get_photos do
      set :method, "flickr.people.getPublicPhotos"
      parameter :user_id, :required => true
      parameter :safe_search
      parameter :extras
      parameter :per_page
      parameter :page

      parser :rsp do
        element :status, :attribute => :stat

        element :photos do
          element :page, :attribute => true
          element :pages, :attribute => true
          element :per_page, :attribute => :perpage
          element :total, :attribute => true

          elements :photo do
            element :id, :attribute => true
            element :owner, :attribute => true
            element :secret, :attribute => true
            element :server, :attribute => true
            element :farm, :attribute => true
            element :title, :attribute => true
            element :ispublic, :attribute => true
            element :isfriend, :attribute => true
            element :isfamily, :attribute => true
          end
        end
      end
    end

    action :get_user_by_username do
      set :method, "flickr.people.findByUsername"
      parameter :username, :required => true

      parser :rsp do
        element :status, :attribute => :stat

        element :user do
          element :id, :attribute => true
          element :nsid, :attribute => true
          element :username
        end
      end
    end
  end
end

FakeWeb.register_uri(:get, 'http://api.flickr.com/services/rest?api_key=secret&method=flickr.people.findByUsername&username=duncandavidson', :string => <<-RESPONSE)
  <?xml version="1.0" encoding="utf-8" ?>
  <rsp stat="ok">
    <user id="59532755@N00" nsid="59532755@N00">
      <username>duncandavidson</username>
    </user>
  </rsp>
RESPONSE

FakeWeb.register_uri(:get, 'http://api.flickr.com/services/rest?user_id=59532755@N00&per_page=3&method=flickr.people.getPublicPhotos&api_key=secret', :string => <<-RESPONSE)
<?xml version="1.0" encoding="utf-8" ?>
<rsp stat="ok">
  <photos page="1" pages="2610" perpage="3" total="7830">
    <photo id="3508500178" owner="59532755@N00" secret="2ebe0307e3" server="3562" farm="4" title="Rich Kilmer" ispublic="1" isfriend="0" isfamily="0" />
    <photo id="3508500140" owner="59532755@N00" secret="10b217377b" server="3593" farm="4" title="Women In Rails" ispublic="1" isfriend="0" isfamily="0" />
    <photo id="3507688713" owner="59532755@N00" secret="83bc8fbf71" server="3620" farm="4" title="Obie Fernandez" ispublic="1" isfriend="0" isfamily="0" />
  </photos>
</rsp>
RESPONSE
