#ifndef HTMLFILTER_H
#define HTMLFILTER_H

#include <QObject>
#include <QString>

class HtmlFilter : public QObject
{
    Q_OBJECT
public:
    explicit HtmlFilter(QObject* parent = 0);

    Q_INVOKABLE QString filter(const QString& html) const;
};

#endif // HTMLFILTER_H
