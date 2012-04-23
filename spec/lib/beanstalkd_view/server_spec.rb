require 'spec_helper'

describe BeanstalkdView::Server, :type => :request do
  
  before :all do
    ENV['BEANSTALK_URL'] = 'beanstalk://localhost/'
    Capybara.app = BeanstalkdView::Server.new
  end

  describe "with beanstalkd daemon running", :requires_beanstalkd => true do
    before :all do
      # Make sure beanstalkd is running
      if `pgrep beanstalkd` == ""
        raise "PRECONDITION NOT MET: beanstalkd not running"
      end
    end

    it "should show the overview at: /" do
      visit '/'
      body.should have_content "Beanstalkd View"
      body.should have_content "Statistics"
      body.should have_content "Tubes"
    end
  
    it "should show the default tube stats at: tube/default" do
      visit '/tube/default'
      body.should have_content "Beanstalkd View"
      body.should have_content "Statistics"
    end
    
    it "show be able to add a job on the overview page", :js => true do
      visit '/'
      form = find('#add_job_form')
      form.click_link('Add Job')
      body.should have_content "Add new job?"
      click_link "confirm_add_job_btn"
      body.should have_content "Added job "
    end
    
  end
  
  describe "with out beanstalkd daemon running" do
    before :all do
      # Make sure beanstalkd is NOT running
      if `pgrep beanstalkd` != ""
        raise "PRECONDITION NOT MET: beanstalkd running"
      end
    end
    
    it "should show error at: /" do
      visit '/'
      page.should have_content "Beanstalk::NotConnected"
    end
  end
  
end