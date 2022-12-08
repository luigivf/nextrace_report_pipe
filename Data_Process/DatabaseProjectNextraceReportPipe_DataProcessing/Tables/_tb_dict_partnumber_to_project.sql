CREATE TABLE [dbo].[_tb_dict_partnumber_to_project] (
    [Partnumber] VARCHAR (100) NOT NULL,
    [Project]    VARCHAR (100) NOT NULL,
    CONSTRAINT [pk_pn_proj] PRIMARY KEY CLUSTERED ([Partnumber] ASC, [Project] ASC)
);


GO

