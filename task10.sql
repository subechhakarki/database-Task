create database collegenoticeboard;
use collegenoticeboard;
-- creating tables--------------------------------------------------------------
create table users (
    user_id int primary key auto_increment,
    username varchar(50) unique not null,
    user_password varchar(50) not null,
    role enum('teacher','student') not null
);

create table notices (
    notice_id int primary key auto_increment,
    title varchar(100) not null,
    content text not null,
    created_by int,
    created_at timestamp default current_timestamp,
    foreign key (created_by) references users(user_id)
);

-- inserting values into tables--------------------------------------------------------------------------------------------
insert into users(username, user_password, role)
values
('ram_teacher', 'teacher123', 'teacher'),
('sita_teacher', 'teacher456', 'teacher'),
('hari_teacher', 'teacher789', 'teacher'),
('gita_teacher', 'teacher111', 'teacher'),
('abinash_teacher', 'teacher222', 'teacher'),
('ramesh_student', 'student123', 'student'),
('sabin_student', 'student456', 'student'),
('nita_student', 'student789', 'student'),
('pratik_student', 'student111', 'student'),
('suman_student', 'student222', 'student');

insert into notices(title, content, created_by)
values
('exam notice', 'mid-term exam starts from next week.', 1),
('holiday notice', 'college will remain closed on friday.', 2),
('seminar notice', 'ai seminar will be held in hall room.', 3),
('sports notice', 'football tournament registration is open.', 4),
('library notice', 'library timing has been extended.', 5),
('project submission', 'final year project submission deadline is sunday.', 1),
('routine update', 'new class routine has been published.', 2),
('internship notice', 'students can apply for internship programs.', 3),
('workshop notice', 'web development workshop starts tomorrow.', 4),
('scholarship notice', 'scholarship forms are available in admin office.', 5);

DELIMITER $$ 
-- registeruser----------------------------------------------------------------------------------------
create procedure registeruser(in p_username varchar(50), in p_password varchar(50), in p_role varchar(20))
begin
    insert into users(username, user_password, role)
    values(p_username, p_password, p_role);
    select 'user registered successfully' as message;
end $$

-- login-----------------------------------------------------------------------------------------------------------------
create procedure userlogin(in p_username varchar(50), in p_password varchar(50))
begin
    select * from users where username = p_username and user_password = p_password;
end $$

-- checkpermission------------------------------------------------------------------------------------------------------------------------
create procedure checkpermission(in p_user_id int)
begin
    declare user_role varchar(20);
    select role into user_role from users where user_id = p_user_id;
    if user_role != 'teacher' then
        signal sqlstate '45000'
        set message_text = 'permission denied! only teachers allowed.';
    end if;
end $$

-- createnotice----------------------------------------------------------------------------------------------------------------------------------
create procedure createnotice(in p_title varchar(100), in p_content text, in p_created_by int)
begin
    call checkpermission(p_created_by);
    insert into notices(title, content, created_by)
    values(p_title, p_content, p_created_by);
    select 'notice created successfully' as message;
end $$

-- viewnotices--------------------------------------------------------------------------------------------------------------------------------------------
create procedure viewnotices()
begin
    select n.notice_id, n.title, n.content, u.username as created_by, n.created_at from notices n join users u on n.created_by = u.user_id;
end $$

-- updatenotice--------------------------------------------------------------------------------------------------------------------------------------------------------
create procedure updatenotice(in p_notice_id int, in p_new_title varchar(100), in p_new_content text, in p_user_id int)
begin
    call checkpermission(p_user_id);
    update notices set title = p_new_title, content = p_new_content where notice_id = p_notice_id;
    select 'notice updated successfully' as message;
end $$

-- deletenotice------------------------------------------------------------------------------------------------------------------------------------------
create procedure deletenotice(in p_notice_id int, in p_user_id int)
begin
    call checkpermission(p_user_id);
    delete from notices where notice_id = p_notice_id;
    select 'notice deleted successfully' as message;
end $$

DELIMITER $$;
-- sampleCallStatements---------------------------------------------------------------------------------------------------------------------------------
-- registerTeacher----------------------------------------------------------------------------------------------------------------------------------------------
call registeruser('Sam_teacher','teacher123','teacher');

-- registerStudent-------------------------------------------------------------------------------------------------------------------------------------------------
call registeruser('hari_student', 'student123', 'student');

-- loginTeacher----------------------------------------------------------------------------------------------------------------------------------------------------
call userlogin('ram_teacher', 'teacher123');

-- loginStudent---------------------------------------------------------------------------------------------------------------------------------------------------
call userlogin('hari_student', 'student123');

-- teacherCreatesNotice---------------------------------------------------------------------------------------------------------------------------------------------------------------
call createnotice('exam notice', 'mid-term exam starts from next week.', 1);

-- viewNotices---------------------------------------------------------------------------------------------------------------------------------------------------
call viewnotices();

-- teacherUpdatesNotice-------------------------------------------------------------------------------------------------------------------------------------------------
call updatenotice(1, 'updated exam notice', 'mid-term exam starts from monday.',1);

-- viewNoticesAgain-------------------------------------------------------------------------------------------------------------------------------------------------------
call viewnotices();

-- teacherDeletesNotice-----------------------------------------------------------------------------------------------------------------------------------------------------------------
call deletenotice(1,1);

-- viewNoticesafterDelete-----------------------------------------------------------------------------------------------------------------------------------
call viewnotices();

-- studentTryingToCreateNotice-----------------------------------------------------------------------------------------------------------------------------------------
-- should show error
call createnotice('fake notice','holiday tomorrow',6);