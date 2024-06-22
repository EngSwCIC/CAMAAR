
    Then('I should be on the password redefinition page') do
        expect(page).to have_current_path(new_user_password_path)
    end

    Then('an email should be sent to {string} containing a link') do |email|
        sleep 0.1
        expect(current_email.subject).to eq("Reset password instructions")
    end

    When('{string} opens the email') do |email|
        open_email(email)
    end

    When('I click {string} link') do |string|
        click_link string
    end

    When('I click {string} email link') do |string|
        current_email.click_link string
    end

    Then('I should be on the password definition page') do
        expect(page).to have_current_path(edit_user_password_path, ignore_query: true)
    end