-- 1. **Customer Serviceの全社員情報を取得してください。所属している社員数も教えてください。**
    
--     取得したい情報
--     - 社員ID
--     - 社員誕生日
--     - 社員フルネーム
--     - 社員性別
--     - 社員が所属している部署

SELECT
    e.emp_no,
    e.birth_date,
    e.first_name,
    e.last_name,
    e.gender,
    d.dept_name
FROM
    employees e
LEFT JOIN
    dept_emp de ON e.emp_no = de.emp_no 
LEFT JOIN
    departments d ON de.dept_no = d.dept_no
WHERE
    d.dept_name = 'Customer Service';

-- 従業員数を集計するクエリ
SELECT
    d.dept_name,
    COUNT(e.emp_no) AS employees_count
FROM
    employees e
LEFT JOIN
    dept_emp de ON e.emp_no = de.emp_no 
LEFT JOIN
    departments d ON de.dept_no = d.dept_no
GROUP BY d.dept_no,d.dept_name
HAVING d.dept_name = 'Customer Service';


-- 2. **全社員情報を取得してください。**
    
--     取得したい情報
    
--     - 社員ID
--     - 社員誕生日
--     - 社員フルネーム(1カラムで表現してください)
--     - 社員が所属している部署名
--     - 役割、階級
--     - 給料
--     - 上司のフルネーム(1カラムで表現してください)
    
--     ルール
    
--     - 方法はどんな方法でもいいので、10秒前後で取得できることを目指しましょう

SELECT
    e.emp_no,
    e.birth_date,
    CONCAT(e.first_name, ' ', e.last_name) AS emp_full_name,
    d.dept_name,
    t.title,
    s.salary,
    CONCAT(m.first_name, ' ', m.last_name) AS mng_name
FROM
    employees e
LEFT JOIN
    dept_emp de ON e.emp_no = de.emp_no
LEFT JOIN
    departments d ON de.dept_no = d.dept_no
-- 上司のフルネームを取得するためのテーブルをサブクエリで作成 → 外部クエリで部署ごとの上司のフルネームを取得
LEFT JOIN
    (
        SELECT
            dm.emp_no,
            dm.dept_no,
            e.first_name,
            e.last_name
        FROM
            dept_manager dm
        INNER JOIN
            employees e ON dm.emp_no = e.emp_no
    ) m ON m.dept_no = d.dept_no
-- 最新の肩書情報を表示 => 社員番号が重複する者はfrom_dateが最新のものを取得
LEFT JOIN
    (
        SELECT
            t1.emp_no,
            t1.title,
            t1.from_date
        FROM
            titles t1
        LEFT JOIN
            titles t2 ON t1.emp_no = t2.emp_no AND t1.from_date < t2.from_date
        WHERE
            t2.emp_no IS NULL
    ) t ON e.emp_no = t.emp_no
-- 最新の給与情報を表示 => 社員番号が重複する者はfrom_dateが最新のものを取得
LEFT JOIN
    (
        SELECT
            s1.emp_no,
            s1.salary,
            s1.from_date
        FROM
            salaries s1
        LEFT JOIN
            salaries s2 ON s1.emp_no = s2.emp_no AND s1.from_date < s2.from_date
        WHERE
            s2.emp_no IS NULL
    ) s ON e.emp_no = s.emp_no;
