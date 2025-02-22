USE [master]
GO
/****** Object:  Database [BTH8]    Script Date: 10/25/2024 9:34:15 AM ******/
CREATE DATABASE [BTH8]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BTH8', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\BTH8.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'BTH8_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\BTH8_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [BTH8] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BTH8].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BTH8] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BTH8] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BTH8] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BTH8] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BTH8] SET ARITHABORT OFF 
GO
ALTER DATABASE [BTH8] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BTH8] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BTH8] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BTH8] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BTH8] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BTH8] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BTH8] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BTH8] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BTH8] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BTH8] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BTH8] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BTH8] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BTH8] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BTH8] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BTH8] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BTH8] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BTH8] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BTH8] SET RECOVERY FULL 
GO
ALTER DATABASE [BTH8] SET  MULTI_USER 
GO
ALTER DATABASE [BTH8] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BTH8] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BTH8] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BTH8] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [BTH8] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'BTH8', N'ON'
GO
USE [BTH8]
GO
/****** Object:  UserDefinedFunction [dbo].[func_GPA_Max]    Script Date: 10/25/2024 9:34:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[func_GPA_Max]()
returns float
as
begin
	return (select top 1 avg(cast (Mark as float)) as GPA
			from Marks 
			group by StudentID
			order by  avg(cast (Mark as float)) desc
			)
end
GO
/****** Object:  UserDefinedFunction [dbo].[func_GPA_Max1]    Script Date: 10/25/2024 9:34:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[func_GPA_Max1]()
returns float
as
begin
	return (select avg(cast (Mark as float)) as GPA
			from Marks 
			group by StudentID
			having avg(cast (Mark as float)) = (select top 1 avg(cast (Mark as float))
								from Marks
								group by StudentID
								order by  avg(cast (Mark as float)) desc
								)
			)
end
GO
/****** Object:  UserDefinedFunction [dbo].[func_SoHocVien_DKMonHoc_MaHV]    Script Date: 10/25/2024 9:34:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[func_SoHocVien_DKMonHoc_MaHV](@mamh int)
returns int
as
begin 
	return (select count(distinct StudentID)
			from Marks
			where SubjectID = @mamh
			group by SubjectID)
end
GO
/****** Object:  UserDefinedFunction [dbo].[func_SoHocVien_HienCo]    Script Date: 10/25/2024 9:34:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[func_SoHocVien_HienCo]()
returns int
as
begin
	return (select count(StudentID) as N'SoSV'
			from Students
			)
end
GO
/****** Object:  Table [dbo].[Classes]    Script Date: 10/25/2024 9:34:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Classes](
	[ClassID] [int] NOT NULL,
	[ClassName] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ClassID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ClassStudent]    Script Date: 10/25/2024 9:34:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClassStudent](
	[ClassID] [int] NOT NULL,
	[StudentID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Marks]    Script Date: 10/25/2024 9:34:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Marks](
	[SubjectID] [int] NOT NULL,
	[StudentID] [int] NOT NULL,
	[Mark] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Students]    Script Date: 10/25/2024 9:34:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Students](
	[StudentID] [int] NOT NULL,
	[StudentName] [varchar](100) NULL,
	[Age] [int] NULL,
	[Email] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[StudentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Subjects]    Script Date: 10/25/2024 9:34:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Subjects](
	[SubjectID] [int] NOT NULL,
	[SubjectName] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[SubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[func_DanhSach_Tuoi]    Script Date: 10/25/2024 9:34:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[func_DanhSach_Tuoi]
(@tuoi1 int, @tuoi2 int)
returns table
as
	return (select *
			from Students
			where Age >= @tuoi1 and Age <= @tuoi2
			)
GO
/****** Object:  UserDefinedFunction [dbo].[func_diemtb]    Script Date: 10/25/2024 9:34:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[func_diemtb]()
returns table
as
	return (select Students.StudentID, StudentName, avg(cast (Mark as float)) as GPA
			from Marks join Students 
			on Marks.StudentID = Students.StudentID
			group by Students.StudentID, StudentName
			)
GO
/****** Object:  UserDefinedFunction [dbo].[func_HocVien_Ho]    Script Date: 10/25/2024 9:34:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[func_HocVien_Ho](@ho nvarchar(50))
returns table
as
	return(select *
			from Students
			where StudentName like N''+ @ho +'%'
			)
GO
/****** Object:  UserDefinedFunction [dbo].[func_Select_Danhsach_Diem_HocVien]    Script Date: 10/25/2024 9:34:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[func_Select_Danhsach_Diem_HocVien]()
returns table
as
	return (select  Subjects.SubjectID,Subjects.SubjectName,Students.*, Marks.Mark
			from Students join Marks on Students.StudentID = Marks.StudentID
							join Subjects on Subjects.SubjectID = Marks.SubjectID
			
			)
GO
/****** Object:  UserDefinedFunction [dbo].[func_Select_DS_HocVien]    Script Date: 10/25/2024 9:34:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[func_Select_DS_HocVien]()
returns table
as 
	return (select* from Students)
GO
INSERT [dbo].[Classes] ([ClassID], [ClassName]) VALUES (1, N'C0706L')
INSERT [dbo].[Classes] ([ClassID], [ClassName]) VALUES (2, N'C0708G')
INSERT [dbo].[ClassStudent] ([ClassID], [StudentID]) VALUES (1, 1)
INSERT [dbo].[ClassStudent] ([ClassID], [StudentID]) VALUES (1, 2)
INSERT [dbo].[ClassStudent] ([ClassID], [StudentID]) VALUES (2, 3)
INSERT [dbo].[ClassStudent] ([ClassID], [StudentID]) VALUES (2, 4)
INSERT [dbo].[ClassStudent] ([ClassID], [StudentID]) VALUES (2, 5)
INSERT [dbo].[ClassStudent] ([ClassID], [StudentID]) VALUES (1, 1)
INSERT [dbo].[ClassStudent] ([ClassID], [StudentID]) VALUES (1, 2)
INSERT [dbo].[ClassStudent] ([ClassID], [StudentID]) VALUES (2, 3)
INSERT [dbo].[ClassStudent] ([ClassID], [StudentID]) VALUES (2, 4)
INSERT [dbo].[ClassStudent] ([ClassID], [StudentID]) VALUES (2, 5)
INSERT [dbo].[Marks] ([SubjectID], [StudentID], [Mark]) VALUES (1, 1, 8)
INSERT [dbo].[Marks] ([SubjectID], [StudentID], [Mark]) VALUES (2, 1, 4)
INSERT [dbo].[Marks] ([SubjectID], [StudentID], [Mark]) VALUES (1, 1, 9)
INSERT [dbo].[Marks] ([SubjectID], [StudentID], [Mark]) VALUES (1, 3, 7)
INSERT [dbo].[Marks] ([SubjectID], [StudentID], [Mark]) VALUES (1, 4, 3)
INSERT [dbo].[Marks] ([SubjectID], [StudentID], [Mark]) VALUES (2, 5, 5)
INSERT [dbo].[Marks] ([SubjectID], [StudentID], [Mark]) VALUES (3, 3, 8)
INSERT [dbo].[Marks] ([SubjectID], [StudentID], [Mark]) VALUES (3, 5, 1)
INSERT [dbo].[Marks] ([SubjectID], [StudentID], [Mark]) VALUES (2, 4, 3)
INSERT [dbo].[Students] ([StudentID], [StudentName], [Age], [Email]) VALUES (1, N'Nguyen Quang An', 18, N'an@yahoo.com')
INSERT [dbo].[Students] ([StudentID], [StudentName], [Age], [Email]) VALUES (2, N'Nguyen Cong Vinh', 20, N'vinh@gmail.com')
INSERT [dbo].[Students] ([StudentID], [StudentName], [Age], [Email]) VALUES (3, N'Nguyen Van Quyen', 19, N'quyen')
INSERT [dbo].[Students] ([StudentID], [StudentName], [Age], [Email]) VALUES (4, N'Pham Thanh Binh', 25, N'binh@com')
INSERT [dbo].[Students] ([StudentID], [StudentName], [Age], [Email]) VALUES (5, N'Nguyen Van Tai Em', 30, N'taiem@sport.vn')
INSERT [dbo].[Subjects] ([SubjectID], [SubjectName]) VALUES (1, N'SQL')
INSERT [dbo].[Subjects] ([SubjectID], [SubjectName]) VALUES (2, N'Java')
INSERT [dbo].[Subjects] ([SubjectID], [SubjectName]) VALUES (3, N'C')
INSERT [dbo].[Subjects] ([SubjectID], [SubjectName]) VALUES (4, N'Visual Basic')
ALTER TABLE [dbo].[ClassStudent]  WITH CHECK ADD FOREIGN KEY([ClassID])
REFERENCES [dbo].[Classes] ([ClassID])
GO
ALTER TABLE [dbo].[ClassStudent]  WITH CHECK ADD FOREIGN KEY([StudentID])
REFERENCES [dbo].[Students] ([StudentID])
GO
ALTER TABLE [dbo].[Marks]  WITH CHECK ADD FOREIGN KEY([StudentID])
REFERENCES [dbo].[Students] ([StudentID])
GO
ALTER TABLE [dbo].[Marks]  WITH CHECK ADD FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subjects] ([SubjectID])
GO
USE [master]
GO
ALTER DATABASE [BTH8] SET  READ_WRITE 
GO
