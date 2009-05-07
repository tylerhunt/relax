require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "an example service's" do
  describe "get_photos action" do
    it "includes :get_photos" do
      Flickr.new.should respond_to(:get_photos)
    end

    it "requires an API key" do
      proc {
        Flickr.new.get_photos
      }.should raise_error(ArgumentError, /missing.*api_key/i)
    end

    it "requires a user ID" do
      proc {
        Flickr.new(:api_key => 'secret').get_photos
      }.should raise_error(ArgumentError, /missing.*user_id/i)
    end

    it "parses the response" do
      flickr = Flickr.new(:api_key => 'secret')
      flickr.get_photos(:user_id => '59532755@N00', :per_page => 3).should == {
        :status => 'ok',
        :photos => {
          :total => '7830',
          :photo => [
            { :ispublic => '1', :isfriend => '0', :owner => '59532755@N00', :isfamily => '0', :secret => '2ebe0307e3', :server => '3562', :farm => '4', :id => '3508500178', :title => 'Rich Kilmer'},
            {:ispublic => '1', :isfriend => '0', :owner => '59532755@N00', :isfamily => '0', :secret => '10b217377b', :server => '3593', :farm => '4', :id => '3508500140', :title => 'Women In Rails'},
            {:ispublic => '1', :isfriend => '0', :owner => '59532755@N00', :isfamily => '0', :secret => '83bc8fbf71', :server => '3620', :farm => '4', :id => '3507688713', :title => 'Obie Fernandez'}
          ],
          :per_page => '3',
          :pages => '2610',
          :page => '1'
        }
      }
    end
  end

  describe "get_user_by_username action" do
    it "includes :get_user_by_username" do
      Flickr.new.should respond_to(:get_user_by_username)
    end

    it "requires an API key" do
      proc {
        Flickr.new.get_user_by_username
      }.should raise_error(ArgumentError, /missing.*api_key/i)
    end

    it "parses the response" do
      flickr = Flickr.new(:api_key => 'secret')
      flickr.get_user_by_username(:username => 'duncandavidson').should == {
        :user => {
          :username => 'duncandavidson',
          :nsid => '59532755@N00',
          :id => '59532755@N00'
        },
        :status => 'ok'
      }
    end
  end
end
