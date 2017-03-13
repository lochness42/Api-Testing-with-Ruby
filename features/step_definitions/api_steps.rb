Given(/^I have an user$/) do
  users = ApiCall.get('users')[:body]
  @user = User.new(users[rand(users.size)])
  expect(ApiCall.get_last_response[:code]).to eq(200)
  # nonfunctional test
  response_time = ApiCall.get_last_response[:time]
  expect(response_time).to be < 0.5, "Request took too long, expected under 0.5, took #{response_time}"
  puts @user.name
  expect(@user.no_nils?).to be(true)
  # tried to follow rules at https://en.wikipedia.org/wiki/Email_address#Syntax
  # stuck with simplified rules (a little bit overcomplicated anyways I know)
  expect(@user.email).to(
      match(/(\w|[!#$%&'*+-\/=?^`{|}~])+(\.(\w|[!#$%&'*+-\/=?^`{|}~])+)*@[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*(\.[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*)+/)
  )
end

And(/^all user's posts' attributes are valid$/) do
  user_posts = ApiCall.get("posts?userId=#{@user.id}")
  expect(ApiCall.get_last_response[:code]).to eq(200)
  @user.set_user_posts(user_posts[:body])
  @user.posts.each { |post|
    expect(post['userId']).to eq(@user.id)
    expect(post['id']).to be_an(Integer)
    # we don't have any specification of valid body and title
    expect(post['title']).to be_an(String)
    expect(post['title']).not_to be('')
    expect(post['body']).to be_an(String)
    expect(post['body']).not_to be('')
  }
end

When(/^I make a post as an user$/) do
  @post_body = {
      title: 'Test post',
      body: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur gravida velit vel magna ornare sollicitudin quis eget nisl. Proin dignissim.',
      userId: @user.id
  }
  ApiCall.post('posts', body: @post_body)
end

Then(/^post has been successful$/) do
  response = ApiCall.get_last_response
  expect(response[:code]).to eq(201)
  @post_body.each_pair { |post_key, post_value|
    expect(response[:body][post_key.to_s]).to eq(post_value)
  }
  expect(response[:body]['id']).to be_an(Integer)
end