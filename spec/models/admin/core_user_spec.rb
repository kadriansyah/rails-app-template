require 'rails_helper'

RSpec.describe Admin::CoreUser, type: :model do
	it "is valid with valid attributes" do
		core_user = Admin::CoreUser.new(username: 'kadriansyah',
										email: 'kadriansyah@gmail.com',
										password: 'password',
										firstname: 'Kiagus Arief',
										lastname: 'Adriansyah')
		expect(core_user).to be_valid
	end

	it "is not valid without a username" do
		core_user = Admin::CoreUser.new(username: nil,
										email: 'kadriansyah@gmail.com',
										password: 'password',
										firstname: 'Kiagus Arief',
										lastname: 'Adriansyah')
		expect(core_user).to_not be_valid
	end

	it "is not valid without a email" do
		core_user = Admin::CoreUser.new(username: 'kadriansyah',
										email: nil,
										password: 'password',
										firstname: 'Kiagus Arief',
										lastname: 'Adriansyah')
		expect(core_user).to_not be_valid
	end

	it "is not valid without a firstname" do
		core_user = Admin::CoreUser.new(username: 'kadriansyah',
										email: 'kadriansyah@gmail.com',
										password: 'password',
										firstname: nil,
										lastname: 'Adriansyah')
		expect(core_user).to_not be_valid
	end

	it "is not valid without a lastname" do
		core_user = Admin::CoreUser.new(username: 'kadriansyah',
										email: 'kadriansyah@gmail.com',
										password: 'password',
										firstname: 'Kiagus Arief',
										lastname: nil)
		expect(core_user).to_not be_valid
	end
end
