use ITIProject
---------------------------------------------------insert branch-------(done)
create procedure add_branch
  @br_name varchar(50),
  @br_phone varchar(50)
as
begin
  begin try
    begin transaction

    insert into Branch (Br_name, Br_phone)
    values (@br_name, @br_phone)

    commit transaction
  END TRY
  BEGIN CATCH
    rollback transaction
    PRINT 'Error: ' + ERROR_MESSAGE()
  END CATCH
END

  --------test------
exec add_branch alex,222222
-----------select----------(done)
create proc get_all_branches
as
begin
  begin try
    select * from Branch
  END TRY
  BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE()
  END CATCH
END

exec get_all_branches
-------------update-----------(done)
create proc update_branch
  @br_id int,
  @br_name varchar(50),
  @br_phone varchar(50)
as
begin
  begin try
    begin transaction

    if exists(select 1 from Branch where Br_id = @br_id)
    begin
      update Branch 
      set Br_name = @br_name, Br_phone = @br_phone
      where Br_id = @br_id
      PRINT 'Branch updated successfully.'
    END
    ELSE
    BEGIN
      PRINT 'Error: Branch ID does not exist.'
    END

    commit transaction
  END TRY
  BEGIN CATCH
    rollback transaction
    PRINT 'Error: ' + ERROR_MESSAGE()
  END CATCH
END

exec update_branch 11,'alexx',222333
------------------------------delete-(done)
use ITIProject
create procedure delete_branch
  @br_id int
as
begin
  begin try
    begin transaction

    if exists (select 1 from Branch where Br_id = @br_id)
    begin
      if exists (select 1 from Br_Track where Br_id = @br_id)
      begin
        select 'Error: The branch ID has related records in Br_Track. Cannot delete.'
      end
      ELSE
      BEGIN
        delete from Branch where Br_id = @br_id
        PRINT 'Branch deleted successfully.'
      END
    END
    ELSE
    BEGIN
      PRINT 'Error: Branch ID does not exist.'
    END

    commit transaction
  END TRY
  BEGIN CATCH
    rollback transaction
    PRINT 'Error: ' + ERROR_MESSAGE()
  END CATCH
END


exec delete_branch 1
------------------------------------------------------br_track insert------------------------(done)
create procedure add_br_track
  @br_id int,
  @tr_id int
as
begin
  begin try
    begin transaction
	if not exists(select 1 from Br_Track where Br_id=@br_id and Tr_id=@tr_id)
	 begin
    if not exists(select 1 from Branch where Br_id = @br_id)
      select 'Error: Branch ID does not exist in the Branch table.'
    ELSE IF NOT EXISTS(SELECT 1 FROM Track WHERE Tr_id = @tr_id)
      select 'Error: Track ID does not exist in the Track table.'
    else
    begin
      insert into Br_Track (Br_id, Tr_id)
      values(@br_id, @tr_id)
      select 'Data inserted successfully into Br_Track.'
    end
	end
	else 
		select'error dublicte key'

    commit transaction
  end try

  begin catch
    rollback transaction
    print 'Error: ' + error_message()
  end catch
end

------test------
exec add_br_track 1,3
exec add_br_track 7,8
exec add_br_track 12,15
-------------select----------
create proc get_all_br_tracks
as
begin
  begin try
    begin transaction

    select * from br_track

    commit transaction
  end try
  begin catch
    rollback transaction
    print 'Error: ' + error_message()
  end catch
end

exec get_all_br_tracks

-------------------------update--------(done)
create procedure update_br_track
    @old_br_id int,
    @old_tr_id int,
    @new_br_id int,
    @new_tr_id int
as
begin
    begin try
        -- ??? ????????
        begin transaction
        
        if exists (select 1 from br_track where br_id = @old_br_id and tr_id = @old_tr_id)
        begin
            if exists (select 1 from branch where br_id = @new_br_id) and exists (select 1 from track where tr_id = @new_tr_id)
            begin
                delete from br_track where br_id = @old_br_id and tr_id = @old_tr_id;
                
                insert into br_track (br_id, tr_id)
                values (@new_br_id, @new_tr_id);
                
                print 'br_track record updated successfully.';
            end
            else
            begin
                print 'error: the new br_id or tr_id does not exist in the respective tables.';
                -- ??? ?? ???? ??? ????? ?????? ??? ??????? ?? ????????
                rollback transaction
            end
        end
        else
        begin
            print 'error: br_track record not found.';
            -- ??? ?? ??? ?????? ??? ?????? ??? ??????? ?? ????????
            rollback transaction
        end
        
        -- ??? ??? ??????? ?????? ??? ????? ?????????
        commit transaction
    end try
    begin catch
        -- ?? ???? ???? ???? ??? ??????? ?? ????????
        rollback transaction
        print 'error: ' + error_message()
    end catch
end


------------------------delete---------------(done)
create procedure delete_br_track
  @br_id int,
  @tr_id int
as
begin
  begin try
    begin transaction

    if exists (select 1 from br_track where br_id = @br_id and tr_id = @tr_id)
    begin
      delete from br_track where br_id = @br_id and tr_id = @tr_id
      print 'Br_Track deleted successfully.'
      commit transaction
    end
    else
    begin
      print 'Error: Br_Track record does not exist.'
      rollback transaction
    end
  end try
  begin catch
    rollback transaction
    print 'Error: ' + error_message()
  end catch
end


exec delete_br_track 3,2
---------------------------------------------------------------------course insert------------------------------------------(done)
create procedure add_course
  @cr_name varchar(50),
  @cr_duration int,
  @ins_id int
as
begin
  begin try
    if not exists(select 1 from instructor where ins_id = @ins_id)
      select 'Error: instructor ID does not exist in the instructor table.'
    else
    begin
      insert into course (cr_name, cr_duration, ins_id)
      values (@cr_name, @cr_duration, @ins_id)
      select 'Data inserted successfully into course.'
    end
  end try
  begin catch
    print 'Error: ' + error_message()
  end catch
end

-----------test-----
exec add_course php,10,5
---------------select-------------(done)
create proc get_all_courses
as
begin
  begin try
    select * from course
  end try
  begin catch
    print 'Error: ' + error_message()
  end catch
end
 exec get_all_courses
---------------------update----------------
create proc update_course
  @cr_id int,
  @cr_name varchar(50),
  @cr_duration int,
  @ins_id int
as
begin
  begin try
    begin transaction

    if exists(select 1 from course where cr_id = @cr_id)
    begin
      if exists(select 1 from instructor where ins_id = @ins_id)
      begin
        update course
        set cr_name = @cr_name, cr_duration = @cr_duration, ins_id = @ins_id
        where cr_id = @cr_id
        print 'Course updated successfully.'
      end
      else
        print 'Error: The instructor does not exist.'
    end
    else
      print 'Error: Course ID does not exist.'

    commit transaction
  end try
  begin catch
    rollback transaction
    print 'Error: ' + error_message()
  end catch
end

exec update_course 1200, 'pphp', 11, 9


exec update_course 1200,pphp,11,9
----------------delete-------------(done)
create proc delete_course
  @cr_id int
as
begin
  begin try
    begin transaction

    if exists(select 1 from course where cr_id = @cr_id)
    begin
      delete from course where cr_id = @cr_id
      print 'Course deleted successfully.'
      commit transaction
    end
    else
    begin
      print 'Error: Course ID does not exist.'
      rollback transaction
    end
  end try
  begin catch
    rollback transaction
    print 'Error: ' + error_message()
  end catch
end

exec delete_course 1100
----------------------------------------------------------------------ex_question inser-------------------------------------------------------
create proc add_ex_question
  @ex_id int,
  @ques_id int
as
begin
  begin try
    begin transaction

    if not exists(select 1 from Ex_question where Ex_id = @ex_id and Ques_id = @ques_id)
    begin
      if not exists(select 1 from Exam where Ex_id = @ex_id)
        select 'Error: Exam ID does not exist in the Exam table.'
      else if not exists(select 1 from Question where Ques_id = @ques_id)
        select 'Error: Question ID does not exist in the Question table.'
      else
      begin
        insert into Ex_question (Ex_id, Ques_id)
        values (@ex_id, @ques_id)
        select 'Data inserted successfully into Ex_question.'
      end
    end
    else
      select 'Duplicate key'

    commit transaction
  end try
  begin catch
    rollback transaction
    print 'Error: ' + error_message()
  end catch
end


exec add_ex_question 5000,7000
---------------select-------------
create proc get_all_ex_questions
as begin
begin try 
	begin transaction
  select * from Ex_question
    commit transaction
end try 
begin catch
rollback transaction
 print 'Error: ' + error_message()
  end catch
 end
exec get_all_ex_questions
----------------update-----------
create proc update_ex_question
  @oldex_id int,
  @oldques_id int,
   @newex_id int,
  @newques_id int
  as begin
  begin try 
	begin transaction
  if exists(select 1 from Ex_question  where Ex_id=@oldex_id and Ques_id=@oldques_id)
	begin 
		if exists(select 1 from Exam where Ex_id=@newex_id)
			begin 
				if exists(select 1 from Question where Ques_id=@newques_id)
					begin
						
						delete from Ex_question 
						where Ex_id=@oldex_id and Ques_id=@oldques_id
						insert into Ex_question (Ex_id,Ques_id)
						values(@newex_id,@newques_id) 
						print'keys updated successfully.'
					end
				else
					print'Error: The new ques_id does not exist in the question table.'
			end
		else
			print'Error: The new ex_id does not exist in the exam table.'
	end
  else 
	print'Error: The record does not exist in ex_question.'
	commit transaction
	end try
	begin catch
	rollback transaction
 print 'Error: ' + error_message()
  end catch
end
exec update_ex_question 19,100,20,103

  ----------------------delete----------------------
  create proc delete_ex_question
  @ex_id int,
  @ques_id int
  as begin 
  begin try 
  begin transaction
		if exists (select 1 from Ex_question where Ex_id=@ex_id and Ques_id=@ques_id)
			begin
				delete from Ex_question where Ex_id=@ex_id and Ques_id=@ques_id
				print' ex_questiondeleted successfully.'
			end
		else 
			print'Error: ex_question record does not exist.'
	commit transaction
	end try
	begin catch
	rollback transaction
 print 'Error: ' + error_message()
  end catch

	end
exec delete_ex_question 31,100
----------------------------------------------------------------------------------exam insert------------------------
create proc add_exam
  @date date,
  @start_ex time,
  @end_ex time,
  @cr_id int
as
begin
  begin try
    begin transaction

    if not exists(select 1 from Course where Cr_id = @cr_id)
    begin
      select 'Error: Course ID does not exist in the Course table.'
    end
    else
    begin
      insert into Exam (date, Start_ex, End_ex, Cr_id)
      values (@date, @start_ex, @end_ex, @cr_id)
      select 'Data inserted successfully into exam.'
    end

    commit transaction
  end try
  begin catch
    rollback transaction
    print 'Error: ' + error_message()
  end catch
end

---------------select-------------
create proc get_all_exams
as
begin
  begin try
    begin transaction

    select * from exam

    commit transaction
  end try
  begin catch
    rollback transaction
    print 'Error: ' + error_message()
  end catch
end

----------------update ------------------------
create proc update_exam
  @ex_id int,
  @date date,
  @start_ex time,
  @end_ex time,
  @newcr_id int
as
begin
  begin try
    begin transaction

    if exists(select 1 from exam where ex_id = @ex_id)
    begin
      if exists(select 1 from course where cr_id = @newcr_id)
      begin
        update exam
        set date = @date,
            start_ex = @start_ex,
            end_ex = @end_ex,
            cr_id = @newcr_id
        where ex_id = @ex_id
        print 'Exam updated successfully.'
      end
      else
        print 'Error: The new Course ID does not exist in the Course table.'
    end
    else
      print 'Error: The exam ID does not exist in the Exam table.'

    commit transaction
  end try
  begin catch
    rollback transaction
    print 'Error: ' + error_message()
  end catch
end

-------------------delete---------
create proc delete_exam
  @ex_id int
as
begin
  begin try
    begin transaction

    if exists(select 1 from exam where ex_id = @ex_id)
    begin
      delete from exam where ex_id = @ex_id
      print 'Exam deleted successfully.'
    end
    else
      print 'Error: The exam ID does not exist in the Exam table.'

    commit transaction
  end try
  begin catch
    rollback transaction
    print 'Error: ' + error_message()
  end catch
end

 --=================================================================================================================================================================
----------------instructor Table-----------------
----Select
create Proc GetInstructorByID
@Ins_Id int
as
begin
	select *
	from Instructor
	where Ins_id = @Ins_id;
end;
----Insert
create Proc AddInstructor
	@Ins_Name varchar(50),
	@Ins_Age int = NULL,
	@Ins_Address varchar(50) = NULL,
	@Ins_Salary int = 5000,
	@Ins_Degree varchar(50) = NULL,
	@Tr_id int = NULL
as
begin
	begin Try
		IF not exists (select 1 from Track where Tr_id = @Tr_id)
        begin
            
            select 'Error: The Track ID does not exist in the Track table.' AS Message;
            return;
        end

		-- Insert the new Instructor record
		insert into Instructor(Ins_name, Ins_age,
								Ins_address, Ins_salary, Ins_Degree,Tr_id)
		values ( @Ins_Name, @Ins_Age, @Ins_Address,
				@Ins_Salary, @Ins_Degree, @Tr_id);

		-- Success message
		SELECT 'Data inserted successfully into Instructor table.' AS Message;

	end Try
	begin Catch
		select 'An error occurred: ' + ERROR_MESSAGE() AS ErrorMessage
	end Catch
end
----Update
create Proc UpdateInstructor
	@Ins_Id int,
	@Ins_Name varchar(50),
	@Ins_Age int = NULL,
	@Ins_Address varchar(50) = NULL,
	@Ins_Salary int = 5000,
	@Ins_Degree varchar(50) = NULL,
	@Tr_id int = NULL
as
begin
	begin Try
		-- Check if the Instructor exists
		if exists (select 1 from Instructor where Ins_id = @Ins_Id)
		begin
			-- Check if the Track ID exists
			if exists (select 1 from Track where Tr_id = @Tr_id)
			begin
				-- Update the Instructor record
				update Instructor
				set Ins_name = @Ins_Name,
					Ins_age = @Ins_Age,
					Ins_address = @Ins_Address,
					Ins_salary = @Ins_Salary,
					Ins_Degree = @Ins_Degree,
					Tr_id = @Tr_id
				where Ins_id = @Ins_Id
				--success message after updating
				SELECT 'Data updated successfully into Instructor table.' AS Message
			end
			else
			begin
				-- If Track ID does not exist
				select 'Error: The new Track ID does not exist in the Track table.' AS Message
			end
		end
		ELSE
        begin
            -- If Instructor ID does not exist
            select 'Error: The Instructor ID does not exist in the Instructor table.' AS Message;
        end
	end Try
	begin Catch
		-- Handle any errors that occur during the procedure
		select 'An error occurred: ' + ERROR_MESSAGE() AS ErrorMessage;
	end Catch
end;
----Delete
create Proc DeleteInstructor @Ins_Id int
as
begin
	begin Try
		if not exists (select 1 from Instructor where Ins_id = @Ins_Id)
		begin
			select 'Error: Instructor ID does not exist in the Instructor table.'  AS Message;
			return;
		end
		-- Delete the Instructor record
        DELETE FROM Instructor WHERE Ins_id = @Ins_Id;

		--success message
		select 'Instructor record deleted successfully.' AS Message;

	end try
	begin catch
		-- Handle any errors that occur during the procedure
		select 'An error occurred: ' + ERROR_MESSAGE() AS ErrorMessage;
	end Catch
end;

----------------Ques_Choice Table-----------------
----Select
create Proc GetQuesChoice @Ques_id int
as
begin
	select *
	from Ques_choice
	where Ques_id = @Ques_id;
end
----insert
create Proc AddQuesChoice
	@Ques_id int,
	@Choice varchar(50)
as
begin
	begin try
		if not exists (select 1 from Question where Ques_id = @Ques_id)
		begin
			select 'Error: Question ID does not exist in the Question table.' AS Message;
			return;
		end

		-- Check if the combination of Ques_id and choice already exists
		if exists (select 1 from Ques_choice where Ques_id = @Ques_id and choise = @Choice)
		begin
			select 'Error: The choice already exists for this Question ID.' AS Message;
			return;
		end
		-- Insert the new choice record
		insert into Ques_choice
		values (@Ques_id, @Choice);

		select 'Data inserted successfully into Ques_choice table.' AS Message;
	end try
	begin catch
		select 'An error occurred: ' + ERROR_MESSAGE() AS ErrorMessage;
	end catch
end;
----update
create Proc UpdateQuesChoice
	@Ques_id int,
	@Choice varchar(50),
	@New_Choice varchar(50)
as
begin
	begin try
		-- Check if the Ques_id exists
		if not exists (select 1 from Question where Ques_id = @Ques_id)
		begin
			select 'Error: Question ID does not exist in the Question table.' AS Message;
			return;
		end
		-- Check if the combination of Ques_id and Choice exists
		if not exists (select 1 from Ques_choice where Ques_id = @Ques_id and choise = @Choice)
		begin
			select 'Error: The choice does not exist for this Question ID.' AS Message;
			return;
		end
		-- Check if the new choice already exists
		if exists (select 1 from Ques_choice where Ques_id = @Ques_id and choise = @New_Choice)
		begin
			select 'Error: The new choice already exists for this Question ID.' AS Message;
			return;
		end

		-- Update the choice
		update Ques_choice
		set choise = @New_Choice
		where Ques_id = @Ques_id and choise = @Choice;

		select 'Data updated successfully in Ques_choice table.' AS Message;
	end try
	begin catch
		select 'An error occurred: ' + ERROR_MESSAGE() AS ErrorMessage;
	end catch
end;
----Delete
create Proc DeleteQuesChoice
	@Ques_id int,
	@Choice varchar(50)
as
begin
	begin try
		-- Check if the Ques_id exists
		if not exists (select 1 from Question where Ques_id = @Ques_id)
		begin
			select 'Error: Question ID does not exist in the Question table.' AS Message;
            RETURN;
		end

		-- Check if the combination of Ques_id and choice exists
		if not exists (select 1 from Ques_choice where Ques_id = @Ques_id and choise = @Choice)
		begin
			select 'Error: The choice does not exist for this Question ID.' AS Message;
			return;
		end

		--Delete The Choice record
		delete from Ques_choice
		where Ques_id = @Ques_id and choise = @Choice;

		select 'Data deleted successfully from Ques_choice table.' AS Message;

	end try
	begin catch
		select 'An error occurred: ' + ERROR_MESSAGE() AS ErrorMessage;
    end catch;
end;

----------------Question Table-----------------
----Select
create Proc GetQuestion @Ques_id int
as
begin
	select *
	from Question
	where Ques_id = @Ques_id;
end

----insert
create Proc AddQuestion
    @Ques_content VARCHAR(500),
    @Type VARCHAR(50),
    @Correct_ans VARCHAR(500),
    @Ques_point INT = NULL,
    @Cr_id INT = NULL
as
begin
	begin try
		--check if it exists in Course table
		if @Cr_id is not Null and not exists (select 1 from Course where Cr_id = @Cr_id)
		begin
			
			select 'Error: Course ID does not exist in the Course table.' AS Message;
			return;
		end
		
		insert into Question
		values (@Ques_id, @Ques_content, @Type, @Correct_ans, @Ques_point, @Cr_id)
		
		select 'Data inserted successfully into Question table.' AS Message;
	end try
	begin catch
		
		select 'An error occurred: ' + ERROR_MESSAGE() AS ErrorMessage;
	end catch
end

----update
create Proc UpdateQuestion
    @Ques_id INT,
    @Ques_content VARCHAR(500),
    @Type VARCHAR(50),
    @Correct_ans VARCHAR(500),
    @Ques_point INT = NULL,
    @Cr_id INT = NULL
as
begin
	begin try
		-- Check if the Ques_id already exists
		if not exists (select 1 from Question where Ques_id = @Ques_id)
		begin
			select 'Error: Question ID does not exist in the Question table.' AS Message;
			return;
		end

		--check if it exists in Course table
		if @Cr_id is not Null and not exists (select 1 from Course where Cr_id = @Cr_id)
		begin
			select 'Error: Course ID does not exist in the Course table.' AS Message;
			return;
		end
		
		-- Update the question details
        update Question
        set Ques_content = @Ques_content,
            Type = @Type,
            Correct_ans = @Correct_ans,
            Ques_point = @Ques_point,
            Cr_id = @Cr_id
        WHERE Ques_id = @Ques_id

		select 'Data updated successfully in Question table.' AS Message;
	end try
	begin catch
		select 'An error occurred: ' + ERROR_MESSAGE() AS ErrorMessage
	end catch
end;

----Delete
create Proc DeleteQuestion
	@Ques_id int
as
begin
	begin try
		if not exists (select 1 from Question where Ques_id = @Ques_id)
		begin
			select 'Error: Question ID does not exist in the Question table.' AS Message;
            return;
        end

		-- Delete the question record
		delete from Question
		where Ques_id = @Ques_id

		select 'Data deleted successfully from Question table.' AS Message;
	end try
	begin catch
		select 'An error occurred: ' + ERROR_MESSAGE() AS ErrorMessage
	end catch
end;

----------------St_answer Table-----------------
create Proc GetStudentAnswer
	@St_id int,
	@Ex_id int,
	@Ques_id int
as
begin
	select *
	from St_answer
	where St_id = @St_id and Ex_id = @Ex_id and Ques_id = @Ques_id;
end


----insert
create Proc InsertStAnswer
    @St_id INT,
    @Ex_id INT,
    @Ques_id INT,
    @Answer VARCHAR(200) = NULL
as
begin
	begin try
		-- Check if the St_id exists in Student table
		if not exists (select 1 from Student where St_id = @St_id)
		begin
            select 'Error: Student ID does not exist in the Student table.' AS Message;
            return;
        end

		-- Check if the Ex_id exists in Exam table
		if not exists (select 1 from Exam where Ex_id = @Ex_id)
        begin
            select 'Error: Exam ID does not exist in the Exam table.' AS Message;
            return;
        end

		-- Check if the Ques_id exists in Question table
		if not exists (select 1 from Question where Ques_id = @Ques_id)
        begin
            select 'Error: Question ID does not exist in the Question table.' AS Message;
            return;
        end
		-- Check if the combination of St_id, Ex_id, and Ques_id already exists
		if exists (select 1 from St_answer where St_id = @St_id
											and Ex_id = @Ex_id 
											and Ques_id = @Ques_id)
		begin
			select 'Error: The answer already exists for this Student, Exam, and Question.' AS Message;
			return;
		end

		insert into St_answer (St_id,Ex_id,Ques_id,answer)
		values (@St_id, @Ex_id, @Ques_id, @Answer);

		select 'Data inserted successfully into St_answer table.' AS Message;
	end try
	begin catch
		select 'An error occurred: ' + ERROR_MESSAGE() AS ErrorMessage
	end catch
end;

select * from St_answer
----Update
create Proc UpdateStAnswer
	@St_id INT,
    @Ex_id INT,
    @Ques_id INT,
    @Answer VARCHAR(50),
    @Points INT
as
begin
	begin try
		-- Check if the combination of St_id, Ex_id, and Ques_id already exists
		if not exists (select 1 from St_answer where St_id = @St_id
											and Ex_id = @Ex_id 
											and Ques_id = @Ques_id)
		begin
			select 'Error: The answer does not exist for this Student, Exam, and Question.' AS Message;
			return;
		end

		-- Update the answer for the student
		UPDATE St_answer
        set answer = @Answer,
            points = @Points
        where St_id = @St_id AND Ex_id = @Ex_id AND Ques_id = @Ques_id;

		select 'Data updated successfully in St_answer table.' AS Message;

	end try
	begin catch
		select 'An error occurred: ' + ERROR_MESSAGE() AS ErrorMessage
	end catch
end;
----Delete
create Proc DeleteStAnswer
	@St_id INT,
    @Ex_id INT,
    @Ques_id INT
as
begin
	begin try
		-- Check if the combination of St_id, Ex_id, and Ques_id already exists
		if not exists (select 1 from St_answer where St_id = @St_id
											and Ex_id = @Ex_id 
											and Ques_id = @Ques_id)
		begin
			select 'Error: The answer does not exist for this Student, Exam, and Question.' AS Message;
			return;
		end

		-- Delete the answer for the student
		delete from St_answer
		where St_id = @St_id and Ex_id = @Ex_id and Ques_id = @Ques_id;

		select 'Data deleted successfully from St_answer table.' AS Message;
	end try
	begin catch
		select 'An error occurred: ' + ERROR_MESSAGE() AS ErrorMessage
	end catch
end;

----------------St_course Table-----------------
----Select
create Proc GetStudentCourse
	@St_id int,
	@Cr_id int
as
begin
	select *
	from St_course
	where St_id = @St_id and Cr_id = @Cr_id
end

----insert

create Proc InsertStCourse
    @St_id int,
	@Cr_id int
as
begin
	begin try
		-- Check if the St_id exists in Student table
		if not exists (select 1 from Student where St_id = @St_id)
		begin
            select 'Error: Student ID does not exist in the Student table.' AS Message;
            return;
        end

		-- Check if the Cr_id exists in Course table
		if not exists (select 1 from course where Cr_id = @Cr_id)
		begin
            select 'Error: Course ID does not exist in the Course table.' AS Message;
            return;
        end

		-- Check if the combination of St_id and Cr_id already exists
		if exists (select 1 from St_course where Cr_id = @Cr_id and St_id = @St_id)
		begin
			select 'Error: The Course already exists for this Student ID.' AS Message;
			return;
		end

		-- Insert the new record
		insert into St_course
		values (@St_id, @Cr_id);

		select 'Data inserted successfully into St_course table.' AS Message;
	end try
	begin catch
		select 'An error occurred: ' + ERROR_MESSAGE() AS ErrorMessage
	end catch
end;

----Delete
CREATE PROC DeleteStCourse
    @St_id INT,
    @Cr_id INT
AS
BEGIN

    -- Check if record exists
    IF NOT EXISTS (SELECT 1 FROM St_course WHERE St_id = @St_id AND Cr_id = @Cr_id)
    BEGIN
        select 'Record does not exist'
        RETURN;
    END

    -- Delete the record
    DELETE FROM St_course 
    WHERE St_id = @St_id AND Cr_id = @Cr_id;

    SELECT 'Course enrollment deleted successfully' AS Message;
END


-- [Select] [Insert] [Update] [Delete] For Table [St_exam] [Student] [Topic] [Track]

-- Select  using Dynmic Query

Create Proc Get_St_Exam @x nvarchar(20)
as
	If @x  = '*'
		begin
			exec ('Select * From St_Exam')
		end
	else
		begin
		 exec ('select ' + @x +' From St_Exam ')
		end
Get_St_Exam 'St_id'







-- Delete 



create Proc Delete_StExam
@Sid int 
as 
	begin
		begin try
			if not exists (select 1 from St_exam where  St_id = @Sid )
				print 'Error : Because This Row Is Not Exsite In St_Exam To Delete';

				delete from St_exam
				where St_id = @Sid 
		end try
		begin catch
			print 'An Error occured ' + Error_Message()
		end catch
	end;

-- Test

Delete_StExam 4 


--------------------------------------------------[Student]-----------------------------------------------

-- Select  using Dynmic Query

Create Proc GetStudentDetails @x nvarchar(20)
as
	If @x  = '*'
		begin
			exec ('Select * From Student')
		end
	else
		begin
		 exec ('select ' + @x +' From Student')
		end
-- Test

GetStudentDetails 'tr_id'
GetStudentDetails '*'

-- Insert

create Proc InsertNewStudent
(
 @St_FirstName varchar (20) , @St_LastName varchar (20),
@age int , @address varchar(20)= NULL , @TrId int , @joinDate date = NULL ,
@duration int , @gender varchar(1)
)
as
	begin
		begin try

			if not exists (select 1 from Track where Tr_id = @TrId)
				print 'Error Beccause Tr You Enter Is Not Exists In Table Track';
			if @gender != 'M' and @gender != 'F'
				print 'Error Because You Must Enter "M" Or "F"';

			insert into Student
			values (@St_FirstName,@St_LastName,@age,@address,@TrId,@joinDate,@duration,@gender)
		end try
		begin catch
			print 'Error Occuerd' + Error_Message();
		end catch
	end;
	
-- Test

 InsertNewStudent 
    @St_FirstName = 'John', 
    @St_LastName = 'Doe', 
    @age = 22, 
    @address = '123 Main St', 
    @TrId = 2, 
    @joinDate = '2024-01-01', 
    @duration = 4, 
    @gender = 'M';  -- Error Because St_id Is Alearldy Exist

-- Update

create proc UpdateStudent
(
@Sid int , @St_FirstName varchar (20) , @St_LastName varchar (20),
@age int , @address varchar(20)= NULL , @TrId int , @joinDate date = NULL ,
@duration int , @gender varchar(1)
)

as
	begin
		begin try 
		if not exists (select 1 from student where St_id = @Sid)
			begin
				Print 'Error Because StId You Enter Is Not exsits in Table Student '
				return;
			end
			if not exists (select 1 from Track where Tr_id = @TrId)
				print 'Error Because TrId You Enter Is Not exsits in Table Track';
			if @gender != 'M' and @gender != 'F'
				print 'Error Because You Must Enter "M" Or "F"';
			
			update Student
			set St_fname = @St_FirstName , St_lname = @St_LastName , 
			age = @age , address = @address , Tr_id = @TrId , Join_date = @joinDate,
			[duration(M)] = @duration , gender = @gender
			where St_id = @Sid
		end try
		begin catch
			print 'An Error Occured' + Error_Message();
		end catch
	end;

-- Test

	UpdateStudent 
    @Sid = 16, 
    @St_FirstName = 'John', 
    @St_LastName = 'Doe', 
    @age = 22, 
    @address = '123 Main St', 
    @TrId = 2,  
    @duration = 4, 
    @gender = 'M'; -- Error Because You Must Enter "M" Or "F"


-- Delete

create Proc DeleteStudentDetails
@Sid int 
as
	begin
		begin try
			if not exists (select 1 from Student where St_id = @Sid)
				print 'Error Because St_id Is Not Exists To Delete';
			delete from Student
			where St_id = @Sid 
		end try
		begin catch
			Print 'Error Occured ' + Error_Message();
		end catch
	end;
DeleteStudentDetails 1



---------------------------------------------[Topic]---------------------------------------------------------

-- Select  using Dynmic Query

Create Proc GetTopicDetails @x nvarchar(20)
as
	If @x  = '*'
		begin
			exec ('Select * From Topic')
		end
	else
		begin
		 exec ('select ' + @x +' From Topic')
		end
-- Test

GetTopicDetails 'Top_id'
GetTopicDetails '*'

select * from Topic



-- Insert

Create Proc InsertIntoTopic
 (@TopName varchar(20) , @CrID int)
as
	begin
		begin try
			if not exists (Select 1 from Course Where Cr_id = @CrID)
				begin
					print 'Error Because This CrId Is Not Existe In Table Course';
					return;
				end
				insert into Topic
				values ( @TopName , @CrID)
		end try
		begin catch
			print 'Error Ouccured' + Error_Message();
		end catch
	end;

EXEC InsertIntoTopic @TopName = 'Algebra', @CrID = 1; -- Error Because This CrId Is Not Existe In Table Course
EXEC InsertIntoTopic @TopName = 'Algebra', @CrID = 100;


-- Update 

create Proc UpdateTopic 
(@TopID int,@TopName varchar(20) , @CrID int)
as
	begin
		begin try
		        -- Check if the record with the given ID exists
        if not exists(SELECT 1 FROM Topic WHERE Top_id= @TopID)
			BEGIN
				PRINT 'Error: Record with the given ID does not exist';
            RETURN;
			END
			if not Exists(Select 1 from Course where cr_id = @CrID)
				begin
					print 'Error Becasue This CrId Is not Exsits In Table Cousre';
					return;
				end
				update Topic
				set Top_name = @TopName , Cr_id = @CrID
				where Top_id =@TopID 
		end try
		begin catch
			print 'Error Occurred: ' + ERROR_MESSAGE();
		end catch
	end;

-- Testing

EXEC UpdateTopic  1,   'Ali Updated',   100;


-- Delete 

create Proc DeleteTopic
(@TopId int)
as
	begin
		begin try
				if not exists (select 1 from Topic where Top_id= @TopId)
				begin
					print 'Error Because Topic_id Is Not Exists To Delete';
					return;
				end
			delete from Topic
			where Top_id = @TopId
		end try
		begin catch
			print 'Error Occuerd ' + Error_Message();
		end catch
	end;

-- Test

DeleteTopic 100

-------------------------------------[Track]---------------------------------------

-- Select  using Dynmic Query

Create Proc GetTrackDetails @x nvarchar(20)
as
	If @x  = '*'
		begin
			exec ('Select * From Track')
		end
	else
		begin
		 exec ('select ' + @x +' From Track')
		end
-- Test

GetTrackDetails 'Tr_id'
GetTrackDetails '*'

-- Insert

create Proc InsertIntoTrack
( @TrName varchar (20) , @TrDecs varchar(20) , @ManagerID int , @HireDate date)
as
	begin
		begin try
			if not exists(select 1 from Instructor where Ins_id = @ManagerID)
				begin
					print 'Error Because This Id Is Aleardy Not Exsits'
					return;
				end
				insert into Track
				values (@TrName, @TrDecs , @ManagerID , @HireDate)
		end try
		begin catch
			print 'Error Ouccerd ' + Error_Message();
		end catch
	end;


-- Update 


create Proc UpdateTrack 
(@TrID int , @TrName varchar (20) , @TrDecs varchar(20) , @ManagerID int , @HireDate date)
as
	begin
		begin try
		        -- Check if the record with the given ID exists
        if not exists(SELECT 1 FROM Track WHERE Tr_id= @TrID)
			BEGIN
				PRINT 'Error: Record with the given ID does not exist';
            RETURN;
			END
			if not Exists(Select 1 from Instructor where Ins_id = @ManagerID)
				begin
					print 'Error Becasue This InsID Is not Exsits In Table Instrcutors';
					return;
				end
				update Track
				set Tr_name = @TrName, Tr_decs= @TrDecs , manager_id = @ManagerID ,hire_date = @HireDate
				where Tr_id =@TrID
		end try
		begin catch
			print 'Error Occurred: ' + ERROR_MESSAGE();
		end catch
	end;

-- Delete


Create Proc DeleteTrack
(@TrID int)
as
	begin
		begin try
				if not exists (select 1 from Track where Tr_id= @TrID)
				begin
					print 'Error Because TrackID Is Not Exists To Delete';
					return;
				end
			delete from Track
			where Tr_id = @TrID
		end try
		begin catch
			print 'Error Occuerd ' + Error_Message();
		end catch
	end;



--------------------------------------------------------------------------------------------------------------
----------------------------------------[Triggers]------------------------------------------------------------
create trigger t1 
on st_answer 
after insert 
as
  UPDATE st_answer
SET points = CASE 
                WHEN (select answer from inserted) = (select Correct_ans from Question where Ques_id = (select Ques_id from inserted))
				THEN (select Ques_point from Question where Ques_id = (select Ques_id from inserted))
                ELSE 0
             END
FROM st_answer
JOIN question ON st_answer.Ques_id = question.Ques_id
where St_answer.St_id = (select st_id from inserted) and St_answer.Ex_id = (select ex_id from inserted)
and St_answer.Ques_id = (select Ques_id from inserted);
---------------------------------------------------------------------------------------------------------------
create trigger t2 
	on st_exam 
	after insert 
	as
	update St_exam 
	set Total_degree = (select sum(points) from St_answer 
	where st_id = (select st_id from inserted) and Ex_id = (select Ex_id from inserted))
	where st_id = (select st_id from inserted) and Ex_id = (select Ex_id from inserted)
-------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------[Exam Generation]----------------------------------------------------------------
-- 

alter Proc GenerateExam
(@CrId int , @ExamDate date , @StartTime Time  , @EndTime Time , @TOrFQuestions int , @McqQuestions int )
as
	begin
		begin try

		        -- Check if Cr_id exists in the Course table
				 IF NOT EXISTS (SELECT 1 FROM Course WHERE Cr_id = @CrId)
				 BEGIN
				     print 'Invalid Cr_id: No matching Course found.'
				     return;
				 END;

				-- Ensure that we request at least 2 questions
				if (@TOrFQuestions + @McqQuestions) < 2
				begin
				    print 'You must request at least 2 questions.'
				    return;
				end

		        -- Start a transaction
				BEGIN TRANSACTION;

			 -- Step 1: Insert the exam record into the Exam table
			 declare @Ex_id int; -- Variable to store the newly created Exam ID
			 
			 insert into Exam (date, Start_ex, End_ex, Cr_id)
			 values (@ExamDate, @StartTime, @EndTime, @CrId);

				-- Get the newly created Exam ID
				Set @Ex_id = SCOPE_IDENTITY();


				-- Step 3: insert  True/False questions from the Question table and insert them into Ex_Question
				Insert into Ex_Question (Ex_id, Ques_id)
				select top (@TOrFQuestions) @Ex_id, Ques_id
				from Question
				where Cr_id = @CrId AND type = 'TorF' and not exists( select 1 from Ex_Question eq where eq.Ques_id = Question.Ques_id AND eq.Ex_id = @Ex_id) 
				order by NEWID();  -- Randomly select True/False questions

				-- Step 4: insert MCQ questions from the Question table and insert them into Ex_Question
				insert into Ex_Question (Ex_id, Ques_id)
				select top (@McqQuestions) @Ex_id, Ques_id
				from Question
				where Cr_id = @CrId AND type = 'MCQ' and not exists (select 1 from Ex_Question eq where eq.Ques_id = Question.Ques_id AND eq.Ex_id = @Ex_id) 
				order by NEWID();  -- Randomly select MCQ questions

				-- Step 5: Fetch the questions linked to the exam and display them
				select q.Ques_id, q.Ques_content, q.type, q.Correct_ans, q.Ques_point
				from Question q
				inner join Ex_Question eq on q.Ques_id = eq.Ques_id
				where eq.Ex_id = @Ex_id;

				-- Commit the transaction
				COMMIT TRANSACTION;

				-- Optional: Return the Exam ID
				Select @Ex_id AS GeneratedExamID;
		end try

		BEGIN CATCH
		    -- Rollback the transaction in case of error
		    ROLLBACK TRANSACTION;

		    -- Return error information
		    THROW;
		END CATCH;
	end;

	-- Test

	EXEC GenerateExam
    @CrId = 200,
    @ExamDate = '2024-12-6',
    @StartTime = '10:00:00',
    @EndTime = '12:00:00',
    @TOrFQuestions =15
   ,@McqQuestions = 5;
   ---------------------------------------------------------------------------------------------------------------------------------
   -----------------------------------------------------[Exam Answers]--------------------------------------------------------------

	alter procedure insert_student_answers 
    @student_id int,
    @exam_id int,
    @answer1 varchar(50),
    @answer2 varchar(50),
    @answer3 varchar(50),
    @answer4 varchar(50),
    @answer5 varchar(50),
    @answer6 varchar(50),
    @answer7 varchar(50),
    @answer8 varchar(50),
    @answer9 varchar(50),
    @answer10 varchar(50)
as
begin
    begin try
        -- التحقق من وجود الطالب
        if not exists (select 1 from student where st_id = @student_id)
        begin
            print 'Error: Student with ID ' + cast(@student_id as varchar) + ' does not exist.';
            return;
        end

        -- التحقق من وجود الامتحان
        if not exists (select 1 from exam where ex_id = @exam_id)
        begin
            print 'Error: Exam with ID ' + cast(@exam_id as varchar) + ' does not exist.';
            return;
        end

        -- التحقق من أن الطالب مشترك في الكورس الخاص بالامتحان
        if exists (
            select 1
            from st_course s
            join exam e on s.cr_id = e.cr_id
            where e.ex_id = @exam_id and s.st_id = @student_id
        )
        begin
            -- إدخال الإجابات
            ;with question_with_row as (
                select eq.ques_id, row_number() over (order by eq.ques_id) as row_num
                from ex_question eq
                where eq.ex_id = @exam_id
            )
            insert into st_answer (st_id, ex_id, answer, ques_id)
            select 
                @student_id, 
                @exam_id,
                case 
                    when row_num = 1 then @answer1
                    when row_num = 2 then @answer2
                    when row_num = 3 then @answer3
                    when row_num = 4 then @answer4
                    when row_num = 5 then @answer5
                    when row_num = 6 then @answer6
                    when row_num = 7 then @answer7
                    when row_num = 8 then @answer8
                    when row_num = 9 then @answer9
                    when row_num = 10 then @answer10
                end as answer,
                eq.ques_id
            from question_with_row eq
            where row_num <= 10;

            print 'Answers have been successfully inserted for student ID  in exam ID ';
        end
        else
        begin
            print 'Error: The student with ID  is not enrolled in the course for exam ID ';
        end
    end try
    begin catch
        print 'An error occurred: ' + ERROR_MESSAGE();
    end catch
end   
 ---------------------------------------------------------------------------------------------------------------------------------
 -----------------------------------------------------[Exam Correction]-----------------------------------------------------------
alter procedure Exam_correction
    @exam_id int,
    @student_id int
as
begin
    begin try
		if exists(select 1 from Exam where Ex_id=@exam_id)
			begin 
				 if exists (select 1 from St_answer where St_id=@student_id)
					begin
						select st.St_fname+' '+st.St_lname as student_name,
							   e.Ex_id,
							   c.Cr_name as course_name,
							   sum(case when sa.answer = q.correct_ans then isnull(sa.points, 0) end) as student_score,
							  cast(sum(case when sa.answer = q.correct_ans then isnull(sa.points, 0) end) * 100.0 / sum(isnull(q.Ques_point, 0)) as decimal(5, 2)) as percent_grade
						from st_answer sa
						inner join question q
							on sa.ques_id = q.ques_id
						inner join ex_question eq
							on eq.ques_id = q.ques_id
						inner join exam e
							on eq.ex_id = e.ex_id
						inner join course c
							on e.Cr_id = c.Cr_id
						inner join student st
							on sa.st_id = st.st_id
						where e.ex_id = @exam_id
						  and st.st_id = @student_id
						group by st.St_fname,st.St_lname, e.Ex_id, c.Cr_name;
					end
					else
						begin
							select 'Error: answers do not exist yet'
						end
			end
			else
				begin
					select 'Error: Exam does not exist'
				end
    end try
    begin catch
        print 'An error occurred during execution. Please check your input values.';
    end catch
END
