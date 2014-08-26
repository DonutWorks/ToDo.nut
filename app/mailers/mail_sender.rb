class MailSender

	def self.send_email_when_create(email, msg_instance)

    title = msg_instance.title
    where = msg_instance.class.name

    mail = Mail.new

    mail.from('donutworks.app@gmail.com')
    mail.to(email)
    mail.subject('[Todo.nut] ' + where + '에 "' + title + '" 를 등록 했습니다.')

    case where 
    when 'Project'
      project =  msg_instance
      template = ERB.new(File.read('app/views/mail/new_project.html.erb')).result(binding)
    when 'History'
      history =  msg_instance
      template = ERB.new(File.read('app/views/mail/new_history.html.erb')).result(binding)  
    when 'Todo'
      todo =  msg_instance
      template = ERB.new(File.read('app/views/mail/new_todo.html.erb')).result(binding)
    end
    
    mail.html_part  do
      content_type 'text/html; charset=UTF-8'
      body template
    end

    mail.deliver!
	end

end