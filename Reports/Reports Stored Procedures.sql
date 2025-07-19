-----------------------------------------[Reporting Stored Procedures]---------------------------------------------------
------------------------------------------[1]---------------------------------------------------------------------------
CREATE procedure get_student_info
 @TR_No INT
as
begin
        select *from  Student
        where
            Tr_id = @TR_No;
end;
go

exec get_student_info @TR_No = 1;

------------------------------------------[2]---------------------------------------------------------------------------

create procedure get_student_grade
    @student_id int
as
begin
    select 
        s.st_id,
        s.St_fname + ' ' + s.St_lname,
        c.Cr_name,
        Total_degree
  from Student s
        join St_exam se on s.St_id = se.St_id
        join Exam e on e.Ex_id = se.Ex_id
        join Course c on c.Cr_id = e.Cr_id

  where s.st_id = @student_id;
end;

exec get_student_grade @student_id = 2;
 
 ------------------------------------------[3]---------------------------------------------------------------------------

create procedure get_instructor_courses
    @ins_id int
as
begin
    set nocount on;
    select 
        c.cr_name,
        count(sc.st_id) as student_count
    from course c
    left join st_course sc on c.cr_id = sc.cr_id
    where c.ins_id = @ins_id
    group by c.cr_name;
end;


exec get_instructor_courses @ins_id = 5;

 ------------------------------------------[4]---------------------------------------------------------------------------

 create procedure get_course_topics
    @cr_id int
as
begin
    select 
        top_id,
        top_name
    from topic
    where cr_id = @cr_id;
end;

exec get_course_topics @cr_id = 100;

 ------------------------------------------[5]---------------------------------------------------------------------------

create procedure get_exam_questions
    @ex_id int
as
begin
    select 
        q.ques_id,
        q.ques_content,
        qc.choise
    from ex_question eq
    inner join question q on eq.ques_id = q.ques_id
    left join ques_choice qc on q.ques_id = qc.ques_id
    where eq.ex_id = @ex_id;
end;


exec get_exam_questions @ex_id = 19;

 ------------------------------------------[6]---------------------------------------------------------------------------

 alter procedure get_exam_questions_with_answers
    @ex_id int,
    @st_id int
as
begin
    select 
        q.ques_id,
        q.ques_content,
        sa.answer as student_answer
		, q.Correct_ans
    from ex_question eq
    inner join question q on eq.ques_id = q.ques_id
    left join st_answer sa on q.ques_id = sa.ques_id and sa.st_id = @st_id and sa.ex_id = @ex_id
    where eq.ex_id = @ex_id;
end;

exec get_exam_questions_with_answers @ex_id = 19, @st_id = 2;

