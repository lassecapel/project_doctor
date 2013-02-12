require 'rubygems'
require 'sinatra/reloader'
require 'slim'

class Defects
  def self.all
    constants.map do |constant|
      const_get constant
    end
  end

  class Defect

    def self.diagnose(repo)
      in_dir(repo) { diagnosis }
    end

    def self.check_recovery(repo)
      in_dir(repo) { diagnosis && recovery }
    end

    def self.in_dir(repo)
      Dir.chdir repo.path
      result = yield
      Dir.chdir File.dirname(__FILE__)
      result
    end
  end

  class CVE20130276

    def self.diagnosis
      !`Ack "attr_protected :" app/models/`.empty?
    end

    def self.recovery
      !`grep "rails (3.2.12)" Gemfile.lock`.empty?
    end

  end
end

class Repo
  attr_reader :name
  def self.all
     Dir.glob("./repos/*").map { |path| new name: File.basename(path) }
  end

  def initialize(options)
    @name = options[:name]
  end

  def path
    "./repos/#{name}"
  end

  def defects
    Defects.all.select do |defect|
      defect.diagnose self
    end
  end

  def cured_defects
    Defects.all.select do |defect|
      defect.check_recovery self
    end
  end
end

class App < Sinatra::Base
  get '/' do
    @repos = Repo.all
    slim :index
  end
end
